class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.108.0/jbang-0.108.0.zip"
  sha256 "c950046fa7d8b17e440197768f96cab1752a2e549f5ec96389fbf4d1f95dba5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6adcd5aee45fb39082db6ab69d23c874299142e505325245495cf7b2acba212"
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
