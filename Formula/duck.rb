class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.8.2.34203.tar.gz"
  sha256 "8ae122f8e3753e2103997b533fb119489bda714dac2604782c1ec5f4542e51a8"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://cyberduck.io/changelog/"
    regex(/href=.*?Cyberduck[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "8fb3d350f06541e8145e38a8ca06cc74a105863fc805b9b4e66622c3a028f6ba" => :big_sur
    sha256 "4f0862871a55a3afc6ac5f93fa5584db0403e6d33790bc2af3407baab82f9dcb" => :arm64_big_sur
    sha256 "95360e1bc4b967811e40d2164007d5df695272dea00458ec2292a0a675f31f36" => :catalina
    sha256 "13d5d1736f118b42c003c6158566486aed8fe1dc1ff020bc835c4f3ece3a55cc" => :mojave
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on xcode: :build

  def install
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
