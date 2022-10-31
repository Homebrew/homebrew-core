class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.4/checkstyle-10.4-all.jar"
  sha256 "c7fd77aea6f734e3f830bd87a1d764991ac4c0102c1bded9da22cba090aed8f4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ec2acf0ae806b098374d3eb41261b645fbbce791289772ad1775179cfd31db6"
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
