class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  license "BSD-3-Clause"

  stable do
    url "https://golang.org/dl/go1.15.5.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.15.5.src.tar.gz"
    sha256 "c1076b90cf94b73ebed62a81d802cd84d43d02dea8c07abdc922c57a071c84f1"

    go_version = version.major_minor
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          branch: "release-branch.go#{go_version}"
    end
  end

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 "61f04e266ba1f69573ae46766f8988029c5a34f4ae4f1ac0951cf3daf4d919d1" => :big_sur
    sha256 "77f172eb6849a0f86eed4fa8eaeb9e8c69223b7f154a86505a7507b4ea78de79" => :catalina
    sha256 "70969a6147bad6960136bdea78063d39b527c993a725ad525a3cf6e9f8ad6fa5" => :mojave
    sha256 "7d39badbe6096ffd120c3e997ee16fd026d12c4037eb055d26290a39f2689582" => :high_sierra
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      url "https://storage.googleapis.com/golang/go1.15.darwin-amd64.tar.gz"
      sha256 "8a5fb9c8587854a84957a79b9616070b63d8842d4001c3c7d86f261cd7b5ffb6"
    end

    on_linux do
      url "https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz"
      sha256 "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95"
    end
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      arch_args = []
      if Hardware::CPU.arm?
        ENV["GOARCH"] = "arm64"
        # Workaround Rosetta 2 signals issues.
        # See https://golang.org/issue/42700.
        ENV["GODEBUG"] = "asyncpreemptoff=1"
        arch_args = ["arch", "-x86_64"]
      end

      ENV["GOROOT_FINAL"] = libexec
      system(*arch_args, "./make.bash", "--no-clean")
    end

    if Hardware::CPU.arm?
      mv Dir["bin/*_arm64/*"], "bin"
      rm_rf Dir["pkg/*_amd64", "pkg/tool/*_amd64"]
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
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

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
