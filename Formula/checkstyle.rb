class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/checkstyle/checkstyle/7.6.1/checkstyle-7.6.1-all.jar"
  sha256 "e05f866715fe7bc264494cdaeb4b20e0aaa1dd3d2c60f88d71363913f9caf947"

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
