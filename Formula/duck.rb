class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.2.5.32097.tar.gz"
  sha256 "920b142e31358392f6da977296a11a1763da5ffb9fe251a1e71024a4a09d8896"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "9b829920bb87cce68d43f703b6a86c052ab0670228909ff7672d5b1f648c930c" => :catalina
    sha256 "03b20c6cefe1d9fc09a86d3dbf6ec52fd1ea84be79d39d8ecbe8d60fa8085447" => :mojave
    sha256 "8ef7bc9c83ebd11b137e57c2f03ea1c5bfc45d33da45845c8b41c264fc564314" => :high_sierra
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
