class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.122.0/jbang-0.122.0.zip"
  sha256 "2decdc489a9dd1aed9046ed617e038c1558ccfa5c98b5db5fc81ef157da3f9e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f512c6ee8f2a243466b8136bd598e381407ae57b1b8153b2e89a5027e1d8e03c"
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
