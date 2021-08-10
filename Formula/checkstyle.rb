class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.45/checkstyle-8.45-all.jar"
  sha256 "5c57ae7cf68ccf9ae4f989b4cd71428ada22f7e983b3f3d9501c88799ae3e77f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efefab1d9d7b3c775dbaaabc3bcf6490c54bc3ba0d098dabc598945af0157876"
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
