class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.9.2/checkstyle-10.9.2-all.jar"
  sha256 "5ec5b34a0fdbc0ff8ee39e28412543aef9a358a559a4bc9f181e3ba25a914946"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, ventura:        "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, monterey:       "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, big_sur:        "16e4323f1ee6c604a1eeacbd95eeb8559959fe4cc522a91ffee107fb3181a40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c3fc06737c24137c545487b30089289fd51f0824b630fa2093f04d01ec37d4"
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
