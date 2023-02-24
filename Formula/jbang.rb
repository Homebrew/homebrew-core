class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.104.0/jbang-0.104.0.zip"
  sha256 "cb5fd26a7f49e7d2f306e8f514b0fbf56effc6b295280e1f2f6b69bba236c6b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef87676d73bfd125de3b53a7294626627b26a0eaeb80ed9b4f8e9e25ed4b695b"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/jbang.jar"
    bin.write_jar_script libexec/"jbang.jar", "jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read

    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
