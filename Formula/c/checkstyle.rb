class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.2/checkstyle-10.12.2-all.jar"
  sha256 "d2fbf4e2f3d13820e3168fe6aa41f819728407c3ef6d4eeaaf21aefa6ce64a13"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d872aa386f541970d2b889c3f6b5354eb98cee1928332beebb624a76ae9a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d497293f6e5a3a2e0dbac81f3cc4898b72f1858ae2f80c22c6d768b0415b4e7"
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
