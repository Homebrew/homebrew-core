class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://bitbucket.org/fantom/fan-1.0/downloads/fantom-1.0.71.zip"
  sha256 "68b2f238548b12a913012d86552e84dc7376e69dac09b56a0488a5330df2f875"

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
