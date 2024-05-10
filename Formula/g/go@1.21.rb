class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.10.src.tar.gz"
  sha256 "900e0afe8900c1ee65a8a8c4f0c5a3ca02dcf85c1d1cb13a652be22c21399394"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.21(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d03a71a17c9b89713cc98db82547351f2029307a23086b60c2ee1252ff82e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565d7eed0cc70c086755addfcc87cb70363ab613e1a6735fee5082a803015c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "249a35ab4398ddb11a079e48f1dc352128ea3b2e59b29ba2b7178332ad22c69a"
    sha256 cellar: :any_skip_relocation, sonoma:         "67d7833bfbc663cf8c81c48a4de51f6c855ecf312559b2efc5c8678ddb498784"
    sha256 cellar: :any_skip_relocation, ventura:        "e9b93928c8117520d7b1387ff2b783a4ee89ba1afb897e5198a3ef674fcc4b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "ecafdfd0c809d5a4e8af17a11098c8a0b16381a8545cdd3ead85446bf3bebe35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54118fb1748957937baceac595ac22efe26e6f19c5ad37dc28db8b907c33cf9"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~EOS
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
    EOS

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end
