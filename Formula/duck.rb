class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-7.9.3.35019.tar.gz"
  sha256 "2c58200b631a71846aa4d5b9bd5c19d7122c4d71a3765aed06b62cd4ffb8fc43"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6d3638018288858c55614a197d3173e5669132970e80fca0c260aaded2d04a57"
    sha256 cellar: :any, big_sur:       "2ed09ecf01af71732d497550766150bafd614694f1e04e895621f7820a99f705"
    sha256 cellar: :any, catalina:      "53e301cc7e18da135e98aa45444bbd0166e194651ea1a585fe8cce3bfbda03a9"
    sha256 cellar: :any, mojave:        "fa13a4640f8053ac3e4427c19d5abc03d73d4218a357c4b37466f481a4bed310"
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
