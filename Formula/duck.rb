class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.0.1.30930.tar.gz"
  sha256 "74201740d460abc7d433760ab3f098617a58ba53fd86708a42bb4007555a269e"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "5505276789ace34e6e0319035bc450ee5835b0135b1a24fb01cdf3e2c3ffc6ce" => :mojave
    sha256 "a2bcdcd8ffceb369657085ac18f0aaff6f0b3b39b61fec9ec99989acd6bb87ac" => :high_sierra
    sha256 "c6124ce5f82f8926c7456d902c73cb37e1c677cadde454bf9d7822e6ad88df1f" => :sierra
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8", :build]
  depends_on "maven" => :build
  depends_on :xcode => :build

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
