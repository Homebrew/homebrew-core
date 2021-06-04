class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.76/fantom-1.0.76.zip"
  sha256 "805befd635700ad2d85993ef02abc6c8df4c8be57b688302ce62f45a693117d3"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e9e4d0966690f028f05ffdee9bc2c9f52e1337933da4fe6b4e7c4bd9ff146ff"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]

    # Select OpenJDK path in the config file
    java_home = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    inreplace "etc/build/config.props", %r{//jdkHome=/System.*$}, "jdkHome=#{java_home}"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: java_home
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
