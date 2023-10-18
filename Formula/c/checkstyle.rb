class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.4/checkstyle-10.12.4-all.jar"
  sha256 "79c59307fe0b73bce091023a9cde55bca7d18b378c11dc865322f47f18801e19"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, ventura:        "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "8047609107fd905bf1eb6f36123e0e682f17108907deb77ce7cd59f8fa53f7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cdab140c071d1b639bf839e17bf211cb10e94428199c435fcf01bb248cfec0"
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
