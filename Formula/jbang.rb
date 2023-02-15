class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.103.1/jbang-0.103.1.zip"
  sha256 "f91a5b43f6ae5486bbe57e443ee6632e79d0746e3210a9bdb66bb0efcfcd658d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00efb60a4a29225f502e62399308ada23d017a22d0e84f2c22b93a1763ab36e9"
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
