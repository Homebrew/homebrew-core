class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "http://fantom.org"
  url "https://bitbucket.org/fantom/fan-1.0/downloads/fantom-1.0.70.zip"
  sha256 "bd4ded8ccdc90102dd9696dffc9b85c29ba56eaaec4fb29a47f8080e3c809a7c"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]

    # Select the macOS JDK path in the config file
    inreplace "etc/build/config.props", "//jdkHome=/System", "jdkHome=/System"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.fan").write <<~EOS
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
