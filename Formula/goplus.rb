class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.39.tar.gz"
  sha256 "abc5ed80ccd5d233c0b90e82b6fa5aaa874c4fe50cc6fe0f30372f96f7e75677"
  license "Apache-2.0"
  revision 1
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "787817b6d30ce045804b5cd4124f2c157ca3ebc04b0f8c49f6c7576b5ea322aa"
    sha256 arm64_big_sur:  "4d9b065bbec3d8b4b9e161c3ac9fdf4517e0301500faf0567fb60b166b336af7"
    sha256 monterey:       "dba5db488bf81f97428478ca4615291d6a09021c06ba77102c144d7f2a97ae63"
    sha256 big_sur:        "fab34d637e3cc69e5ee473f31ce2888092c3dc1cd771942103ec57a28406489a"
    sha256 catalina:       "a59780cc2d6f9170de630ed38da0680b963076a821fb4dd5ee01d73b98ee2db9"
    sha256 x86_64_linux:   "36a85ee921d8c8a65cb03c6b7e57c35ae1fbb4edc8dc529288bf8fd0b21b5507"
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
