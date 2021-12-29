class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.38.tar.gz"
  sha256 "32f364e648f1f1509f04e37925cc98b373a58775d751bdcb9ded7cfd3d57478a"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "76d275b7edf313f7722f3ddb09baae84f93210865d7ec11bd5415474cf28d130"
    sha256 arm64_big_sur:  "6c2590effa547a2873d7b4c32525d8744c4eadd37a357b283316b9d1d2ea5528"
    sha256 monterey:       "40314b64ccb6e576d242c7d0087883f29d1535172d633d919d6a35954b22d4e7"
    sha256 big_sur:        "cf964aee4566b404f9746f0a8ae5b39252dbe27307f782d873c34682d985a57f"
    sha256 catalina:       "f8aa83924359bd6583f25fc15444dd5c49e956621b3cb19e316a2875eabd0c43"
    sha256 x86_64_linux:   "8b5b512b8a61821ff653cbe4ede1f5c699ece7f1e9cf641b475fb69aef9fd23c"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    (buildpath/"VERSION").write "v#{version}"
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
