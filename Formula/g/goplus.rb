class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "5dceb1f7609f91a93861ae75fe051ed7152159b29a2499a656e841bb800f9473"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "f1a2b5272e815e98273ef6133a24e1058f6d026e096327998fbc9eac3cf9b35f"
    sha256 arm64_ventura:  "0651169ef583b91573aefefc8ce58ae105383ab2f7b09edbaff758200c0f2bb7"
    sha256 arm64_monterey: "2bdeac05ea3d9a81f0a5b5e7e43bf45100fc4e41df8d75519ca4c27c7d40a133"
    sha256 sonoma:         "4519794ceb5ded8018c80e4e68cc334da44f87bd897ad92a502838b7fd11cc18"
    sha256 ventura:        "c00d900231d7fe9a9e0d1d63a0496e64615910f35f878de9dddf8031c86f7065"
    sha256 monterey:       "51ed134f630e1036c1288155acd1435c117d1b4afc751cea7f78b9882bf6ce18"
    sha256 x86_64_linux:   "1f7f7d381ce72953613e50844e08e270dc511742a66c2c1ea01c2a1fad03e6e3"
  end

  depends_on "go"

  def install
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
