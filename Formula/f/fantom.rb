class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.84/fantom-1.0.84.zip"
  sha256 "3ea9f6728a43cca961ae4094a4cd8cb381d3dc3c57d08b023c9cb19b334bc4d5"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec9cca9253500e263f652274c2af0ee21c19018dbd87aa6dd2ab1eec996e84b4"
  end

  depends_on "openjdk"

  conflicts_with "flux", because: "both install `flux` binaries"
  conflicts_with "fluxcd", because: "both install `flux` binaries"

  def install
    rm(Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"])

    # Select OpenJDK path in the config file
    java_home = formula_opt_libexec("openjdk")/"openjdk.jdk/Contents/Home"
    inreplace "etc/build/config.props", %r{//jdkHome=/System.*$}, "jdkHome=#{java_home}"

    libexec.install Dir["*"]
    chmod 0755, libexec.glob("bin/*")
    bin.install libexec.glob("bin/*")
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
