class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.0.0.30869.tar.gz"
  sha256 "112e289ebf43f5e40cbbc5d20ea80cd7a4c258a7112cf00046e3364d46b6ba1a"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "8070a47636f4e7060a00fe9573f71ce26c5647ab2100a304bcc1694deb6835aa" => :mojave
    sha256 "a8974d9ebc038d752abb2bb861e58a59259e1a836bd2ef107652de8b88187bce" => :high_sierra
    sha256 "907976c6f876a6e811ef61657af793578caaf51fdc400a38a3569bff6c75d370" => :sierra
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
