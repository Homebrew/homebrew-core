class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.76/fantom-1.0.76.zip"
  sha256 "805befd635700ad2d85993ef02abc6c8df4c8be57b688302ce62f45a693117d3"
  license "AFL-3.0"

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
