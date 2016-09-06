class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/7.1.1/checkstyle-7.1.1-all.jar"
  sha256 "3ef75392db0b11c13a5da12cc0c8017f665473cabd0571fce0254d829f0d42ad"

  bottle :unneeded

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c /sun_checks.xml #{path}`
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $?.exitstatus
  end
end
