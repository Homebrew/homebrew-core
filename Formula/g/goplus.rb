class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "ab74706ad2796255b9da9c4dd40398fb9be6432dcf2f1343478d2e28ed5d677f"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d556727f1e6cb56b06f1851457c6e3b94bfca1d50b87f5f05a90c6ef2346dcdd"
    sha256 arm64_sonoma:  "81c3254b90f1833cdc31dc15e0d1efa32fff8ac8ea8416960f05a67efa245402"
    sha256 arm64_ventura: "d2276d233f29972191e738a151cf429fe550a21cc3e3600a23940de5a9b4e441"
    sha256 sonoma:        "56e4a13c100648a2bede7d14ffded3a54c1676def2f225125206829327e451cc"
    sha256 ventura:       "fd33ec0bacd82b47a82cebe9934ef57c20efdf59f5347f6f645d1883ed20b8c4"
    sha256 x86_64_linux:  "f5d0266671fde199602da645abb1da0c9480217e19037a67303d137debf1f72a"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    system bin/"gop", "mod", "init", "hello"
    (testpath/"hello.gop").write <<~GOP
      println("Hello World")
    GOP

    # Run gop fmt, run, build
    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop 2>&1")
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
