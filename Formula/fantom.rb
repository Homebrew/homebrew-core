class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://bitbucket.org/fantom/fan-1.0/downloads/fantom-1.0.73.zip"
  sha256 "6d87a979b7cfa3b6d944245d12befbe8d19ebfd2d332e65a8620ce360c25191d"

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
