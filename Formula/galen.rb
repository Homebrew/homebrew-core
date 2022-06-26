class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.4.4/galen-bin-2.4.4.zip"
  sha256 "b89ed0ccef4e5ea310563ab3220965f72d5fc182e89e6faadf44780f1c43b88d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06511320c97eebfab1746d201f7f748b8e2d33d8d6ea4da597b1510b004a40e2"
  end

  depends_on "openjdk"

  def install
    libexec.install "galen.jar"
    (bin/"galen").write <<~EOS
      #!/bin/sh
      set -e
      exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/galen.jar:lib/*:libs/*" com.galenframework.GalenMain "$@"
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/galen -v")
  end
end
