class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.3.0.27105.tar.gz"
  sha256 "a0353402df02685ab9053110ad4842600b733e694fd9c31a98780c1fd742c97c"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "34001237200dcb58878ecce6ddc1f4dab67f1e1d0e33703b655dfc226c7d3ef7" => :high_sierra
    sha256 "f173c0133306981da1ac7e172afc5111227f68720f64ffb1ca68da37906f21ba" => :sierra
    sha256 "6ac9acf7221a27068efc0261f2ac8d31be59a2cd0737531fa4bb45526e33ce1d" => :el_capitan
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["when"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["when"].stable.checksum
  end
end
