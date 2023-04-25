class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.106.3/jbang-0.106.3.zip"
  sha256 "aca772bb159bf913be97e0970ba8106ec8a20594270144ffb8b5c52ec7906fc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ba53f1dd6fc4b9257ad989c24bed506b6190d0adb46fd85e248c0a8e32e69a0"
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
