class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.0.25806.tar.gz"
  sha256 "271230bc6158312efd28f06cbe1a9d2581aa068aad3c85aafd1c90f427c8ecf1"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "ee203d6f7300b7c6fbfe448377c3d4a9209bd585260e8973f16802543823a72e" => :sierra
    sha256 "1f8afa5e74bfab87b0427ba80f300f87cba094d72d793446eea669f3de22db1a" => :el_capitan
    sha256 "78500cca8dd776cc4085b4bd12b885f35efa5dfbdd2e376558b351ab438d4b2a" => :yosemite
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    ENV.java_cache
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["libmagic"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["libmagic"].stable.checksum
  end
end
