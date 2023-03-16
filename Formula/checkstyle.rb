class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.9.1/checkstyle-10.9.1-all.jar"
  sha256 "0eeea21cd8715962fd1e770f2e93a06b807e1f20698aac392332869278ed59b3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, ventura:        "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, monterey:       "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, big_sur:        "41f7d019ee41bc2a6a6ac37a100ec113175cae2cb569212aa9eb36d78bddf60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631239098ce7ff29331e8e6b315b6eeac0c719a9e8b64413230c7ea756cfe7d4"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}/checkstyle -c /sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end
