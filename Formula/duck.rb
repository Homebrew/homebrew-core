class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.8.0.34081.tar.gz"
  sha256 "74a6cc18238aa17ab70d1a7f1a2f07f7679482c9cde943508864c60df650b7d7"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://cyberduck.io/changelog/"
    regex(/href=.*?Cyberduck[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "d7acda8325407b4b468bc4a77f4fc0a43c2595e01d57e547453fc2ad7c4bdb62" => :big_sur
    sha256 "54a5a71f9c0032da8dd86d3264f72e1b0b7740d2997ad765a437622929211d6d" => :arm64_big_sur
    sha256 "116069f816c5887019683a33edaab1bac5e72d7c120a299a6c926f0505f7855a" => :catalina
    sha256 "bd2dfa06c8f9815e60401bb58e50ade16c6a363005a52a3261e8c152f46f10ba" => :mojave
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
