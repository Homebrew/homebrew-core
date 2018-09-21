class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.8.0.28825.tar.gz"
  sha256 "75a8ae9897872464459556d65b9db5140071c046395721b9a8ef87df0deb54df"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "4e245cad2cf0f0bae191008561a200f050ab960474dd5fb5ed5cb1050ff8a3ed" => :mojave
    sha256 "fffc4d1804f0419a73c3541dc0137ed433e5e48b49a1416c00989ea41441d39a" => :high_sierra
    sha256 "d8f35c50ad4a8167efda52d5ad836cbc113c4496a2f96e87004800ec0f5a0b3d" => :sierra
    sha256 "c890c105652dde634c83c41674ce944149ea3c96ac4d32bc7455fde552bfd424" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8+", :build]
  depends_on "maven" => :build
  depends_on :xcode => :build

  def install
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
