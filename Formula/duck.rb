class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  head "https://svn.cyberduck.io/trunk/"

  stable do
    # check the changelog for the latest stable version: https://cyberduck.io/changelog/
    url "https://dist.duck.sh/duck-src-6.2.10.26754.tar.gz"
    sha256 "45b4281a788673f838825064a339f2d2f07356f05a76a011aaa2e3e54a267430"

    # Remove for > 6.2.10
    # Upstream commit from 27 Oct 2017 "Fix compile with Java 9."
    patch do
      url "https://github.com/iterate-ch/cyberduck/commit/612a973d11.patch?full_index=1"
      sha256 "4689550c2b31643b89abf8286a9dedbf94860bba5e8a4fd66764d467b6be9157"
    end
  end

  bottle do
    sha256 "707a2209244f1179dfa4943191de1fbc359fe4b65844018d13e22e9c719a3fbf" => :high_sierra
    sha256 "bd4c6ebec0ef8a3ac48d9bfc75789708c74819318b83eb0beb8a2867aade75d3" => :sierra
    sha256 "655c6fafa5fbd111203e5eeb31afbce60dec2b64de01434314a37db466e41075" => :el_capitan
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
