class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.17.0/checkstyle-10.17.0-all.jar"
  sha256 "51c34d738520c1389d71998a9ab0e6dabe0d7cf262149f3e01a7294496062e42"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, sonoma:         "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, ventura:        "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, monterey:       "829060074ffe76478882a5517e237c4936ad0335634477114eac91227d151677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e66124d5dd25287da109802a676ffae490f42de6354869571b322cb840c1041"
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
