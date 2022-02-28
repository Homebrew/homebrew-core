class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.0/checkstyle-10.0-all.jar"
  sha256 "6850961a0347f6fb0542796ddd6535cb0213ea38950ac57d8a25f2e84fd023dd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b570ce9c5078c02d55930e90a0b3fb686a1168f5068db2491e2631d02b86144"
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
