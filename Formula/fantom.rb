class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "http://fantom.org"
  url "https://bitbucket.org/fantom/fan-1.0/downloads/fantom-1.0.69.zip"
  sha256 "eb1fafcf6cbed15a858342e6060de987aa4e95cd2b418f6d7b51c0e71acca6aa"

  bottle :unneeded

  def install
    # Select the macOS JDK path in the config file
    inreplace "etc/build/config.props", "//jdkHome=/System", "jdkHome=/System"
    inreplace "etc/build/config.props", "jdkHome=/C:", "//jdkHome=/System"

    # Mark bin/ executable
    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.fan").write <<-EOS.undent
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
