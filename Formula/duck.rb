class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-7.8.5.34493.tar.gz"
  sha256 "766b29ae7135c3dd0bcce85c910236baa52669c6535fc00eb6446a6b4c7d25c6"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8dd09e8469fbe9d1c0be0272a6815cfad1fc7651ee4ea239d9498d1d88fcc67e"
    sha256 cellar: :any, big_sur:       "b4c0766f9fd17c138ed8a5c27faea80f02c238d5ca05826fd96fc17e55c215fc"
    sha256 cellar: :any, catalina:      "b094b45cc28516ae65ab46d45a03cb5ea417b1d8af836ec32ea0519d2b87f39e"
    sha256 cellar: :any, mojave:        "b8dbbc43fccf1877d03cd327d16c0d131344e364e3bef1b3d0321616cc200b63"
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
