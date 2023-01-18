class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.102.0/jbang-0.102.0.zip"
  sha256 "74f9ec600ac193e158221b3f5b95e156349ace730ed841eab39e2b1205b48622"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "816f2af8b9fbf14749e774c994b3e593e348d9b2ebeaef3efdea556a8a274db1"
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
