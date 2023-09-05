class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.3/checkstyle-10.12.3-all.jar"
  sha256 "76b24edec6658761bd7fcd1cbcf0f8d588e11d9b7be25995f5b4888540eb4caa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, ventura:        "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, monterey:       "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, big_sur:        "88839653c0491f37e58d6e0c3dbf7be81c6a7abf1964da34f60a713ddc597713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885404a66017178bd575212f3eb04d104fd6248c79100a89bb90106be02c8d98"
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
