class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.39.tar.gz"
  sha256 "abc5ed80ccd5d233c0b90e82b6fa5aaa874c4fe50cc6fe0f30372f96f7e75677"
  license "Apache-2.0"
  revision 1
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "f28b542d6a219c6aa78b1aba273320808d856021ece092225ebec34394fa6ac4"
    sha256 arm64_big_sur:  "2b6112cf6d92d8b8ba403513f49fca91435e07cb008e0312f047bf828dfd35a8"
    sha256 monterey:       "90ecc73e7444e82f4c9c4d8eb59665525ffff12ebff3e2524e3cfbb798790df0"
    sha256 big_sur:        "15d1fa6df5c60f44d0ba5149bc278171c60a5467da976505957bb541ee9ab527"
    sha256 catalina:       "efea3c85f4ec6236a5f273d54dba3d41bec76a69cebeb3b15c8b8a4a2e30edae"
    sha256 x86_64_linux:   "c3b8fa7a5fe0440182591f553cc83016378026bb2ae41f7f3fec6f56fd24a4b1"
  end

  # Bump to 1.18 on the next release (1.1.0).
  depends_on "go@1.17"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    libexec.glob("bin/*").each do |file|
      (bin/file.basename).write_env_script(file, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
    end
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

    system Formula["go@1.17"].opt_bin/"go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
