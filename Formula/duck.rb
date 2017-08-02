class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.1.25837.tar.gz"
  sha256 "d8486d84b62cf4f2ccd7f5c6444d5f191067c190d846af506bf68f6d13b4797a"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "bfb814cf22193ab9e03cd49acbb0ff335a53542d998396febb24bf40850d25eb" => :sierra
    sha256 "fb2b2df40f77b1da1404c9065cc6511e057dd87222c950ae45e7b48b2771beee" => :el_capitan
    sha256 "3f06eb3b8d1bea380e2eb78eff38f914e4af324298026bd3c7e4a7ca4b9a4a9e" => :yosemite
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
