class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.123.0/jbang-0.123.0.zip"
  sha256 "f77e3c1962c321bb68b62c105e6c06a59a0fbc7a1ca32274c15a6ca2466242db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0e6fb25bfc11868a84962527dc2e9abdd9497b3c998705f5e0f48b37c0184e6"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system bin/"jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
