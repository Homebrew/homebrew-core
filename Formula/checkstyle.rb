class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.11.0/checkstyle-10.11.0-all.jar"
  sha256 "170f2c1b78809c55db7731a06c3244a0618675df9d4b10ab4b82932ee9c4ca30"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, ventura:        "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, monterey:       "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, big_sur:        "c255bc1a00e8f4a1a1c348247a5067ac46636e06fd62e81053cb2b20b034d831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8aa1826afe1eb8850bbd36947b0b058a7e88ad84063dffc38a211927c324848"
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
