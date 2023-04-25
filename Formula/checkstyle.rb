class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.9.3/checkstyle-10.9.3-all.jar"
  sha256 "ef6f1206d29c613440f2880d317e970f76856f3d781a3c8dbc15648dd88048f1"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, ventura:        "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, monterey:       "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, big_sur:        "94e39432c38b84ea93b40fafc07c809e1e6ba5ea2d8c1086115f2cd9d9fde517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d559df221f54156c9463f5c4c4b2e0917fd360c68764d53b3d2819e96d555921"
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
