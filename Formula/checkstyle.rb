class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.1/checkstyle-10.12.1-all.jar"
  sha256 "2baa508dcbe87f26c612d473d6c4d584fe77e12a09b02860da9b27815308cab6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, ventura:        "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, monterey:       "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1fc4fbc4dd5b02de1c1a0bb364245204bb7562aea69ca52825eaa924e17a177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e21a504ea10defba361514a1a6dcf330e99275245afab7ea4ed7e675ac2e1e3"
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
