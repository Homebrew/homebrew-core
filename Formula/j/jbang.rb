class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.116.0/jbang-0.116.0.zip"
  sha256 "66ecce7021c371d1fe1b01e4bd6ee01aaaa48b10925f7c36bed635b3d1150d2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79d6a7da49c643e131e430f3e538fa083c4bd1b33b287945e4851dcadbbc8e41"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
