class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "http://checkstyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/7.1.2/checkstyle-7.1.2-all.jar"
  sha256 "f30427a19d9634491607bb4c32c4be0e884486df5e1f1824d110ace6d4e52bd1"

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
