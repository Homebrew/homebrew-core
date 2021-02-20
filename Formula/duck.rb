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
    sha256 cellar: :any, arm64_big_sur: "836f520b90f82299b2bdea2bcb34810ab34e863ca16575d528029b174b984fbf"
    sha256 cellar: :any, big_sur:       "167584ddb4cd9fb3deed0cc3727ad1fe88bc40de4bde5f9c24714d10b4486f8c"
    sha256 cellar: :any, catalina:      "987adb83fbe555dc767a1da4b6c1692019490200bab0e8457f8db2db292e1a8a"
    sha256 cellar: :any, mojave:        "dfb078e83aee5e0d52e415c1d7c16d8930d41bc48b2fc80a7f974be8b40313e1"
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
