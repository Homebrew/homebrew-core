class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.83/fantom-1.0.83.zip"
  sha256 "f695b731526a7981f419a61e6265192feff6b18643c45437c317e6420c8ec588"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9698cbdcb6d5dc0f35b8ae8754017021b8a2ae04b057a1fde7c28912736656e"
  end

  depends_on "openjdk"

  conflicts_with "flux", because: "both install `flux` binaries"

  def install
    rm(Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"])

    # Select OpenJDK path in the config file
    java_home = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
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
