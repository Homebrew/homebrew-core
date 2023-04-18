class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.3.tar.gz"
  sha256 "11e676f1ff4a391248747bad9d4c1673d366fcf306bd3e185fee5870afd02fee"
  license "Apache-2.0"
  revision 2
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "75f6f96124f722c26dd06264ff3bb3ff77694338c64e20c8d727e7edecc11dff"
    sha256 arm64_monterey: "caafb5a3d85e5511acc51b6a2ff821db858348262d290fbdd2bf8370d0b3a0c0"
    sha256 arm64_big_sur:  "70081288d225915d98a62fc2776c6048e400f85e4310d654f639d33e68d9b42b"
    sha256 ventura:        "a70c9ea19622e0ce2a4df1d23049df567126aab61f3a7cddda1e85e8be5f547b"
    sha256 monterey:       "3af1922010bb3b1925d9b7482fa155f694376addc092f47ecf6274014a4e8d18"
    sha256 big_sur:        "4581adddb9a68ed623e0fa3c574b6caf0b925302fb85713b0bb620217a2e206c"
    sha256 x86_64_linux:   "4bc9137b87042ada39f1d8e85e94ca26befe4472edd941cef102d61892261eeb"
  end

  # Move to go1.20 once https://github.com/goplus/gop/issues/1350 is resolved
  depends_on "go@1.19"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    libexec.glob("bin/*").each do |file|
      (bin/file.basename).write_env_script file, PATH: "#{Formula["go@1.19"].opt_bin}:$PATH"
    end
  end

  test do
    ENV["GOROOT"] = Formula["go@1.19"].opt_libexec

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

    system Formula["go@1.19"].opt_bin/"go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
