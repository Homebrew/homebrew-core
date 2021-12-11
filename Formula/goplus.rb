class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.36.tar.gz"
  sha256 "d42a9bb5ca1eac3afcee149f585d2ef7737e595619e5b76f2cca79f5b9c8019f"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "d343268d5db1ebce7e70fa24decb6a168bb0e1e7953a7b11d9dd88bc107d029e"
    sha256 arm64_big_sur:  "f7eabd23a0b21ac5babe73b7ecad7958b737d028853d3e480fd3c2e4a693b011"
    sha256 monterey:       "11619c76af282c5a157fa06c2c18e4034dda3e92367a028be1d2c375519810c2"
    sha256 big_sur:        "c491d25a58775c1c8f66a11579b2174a3bebe8c44f2df6391ec6400d3765d650"
    sha256 catalina:       "acaa9f1ca5f65d3253974568ea44272250b68d813db4dd74bfe82278c63b7f73"
    sha256 x86_64_linux:   "55b6e9a043416e7d1bb801197a8e12699ec057b443375f5e3e58bfaa46c13b4f"
  end

  depends_on "go"

  def install
    # Patch version to match the version of gop, currently it get version from git tag
    inreplace "env/version.go", /^\tbuildVersion string$/, "\tbuildVersion string = \"v#{version}\"" unless build.head?

    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
