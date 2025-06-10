class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.0.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.0.src.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.24(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe1f8746745c4bfebd494583aaef24cad42594f6d25ed67856879d567ee66e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe1f8746745c4bfebd494583aaef24cad42594f6d25ed67856879d567ee66e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fe1f8746745c4bfebd494583aaef24cad42594f6d25ed67856879d567ee66e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "69bef555e114b4a2252452b6e7049afc31fbdf2d39790b669165e89525cd3f5c"
    sha256 cellar: :any_skip_relocation, ventura:       "69bef555e114b4a2252452b6e7049afc31fbdf2d39790b669165e89525cd3f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5501ee5aca0f258d5fe9bfaed401958445014495dc115f202d43d5210b45241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    libexec.install Dir["*"]

    cd libexec/"src" do
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    bin.install_symlink Dir[libexec/"bin/go*"]

    rm_r(libexec/"src/debug/elf/testdata")
    rm_r(libexec/"src/runtime/pprof/testdata")
    rm_r(libexec/"src/debug/dwarf/testdata")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~GO
      package main

      /*
      #include <stdlib.h>
      #include <stdio.h>
      void hello() { printf("%s\\n", "Hello from cgo!"); fflush(stdout); }
      */
      import "C"

      func main() {
          C.hello()
      }
    GO

    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end
