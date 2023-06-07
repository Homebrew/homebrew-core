class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.0/checkstyle-10.12.0-all.jar"
  sha256 "a40d4ae7c901677959560ce0d0d158b7ebc0d491ce5bec96e35b7401196abc91"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, ventura:        "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, monterey:       "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "da0412240f09de4e6af3e0b6816cd998335b056f6ca41b5b9ce7d49e00dc07f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5299f07fa7295d1889d84f9e815b9c5c21e155ffb173f83a08422428a34214a4"
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
