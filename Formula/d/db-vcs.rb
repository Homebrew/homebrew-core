class DbVcs < Formula
  desc "Version control for MySQL databases"
  homepage "https://github.com/infostreams/db"
  url "https://github.com/infostreams/db/archive/refs/tags/1.1.tar.gz"
  sha256 "90f07c13c388896ba02032544820f8ff3a23e6f9dc1e320a1a653dd77e032ee7"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "babb3e6342f742d8b4ffa1773605d2c946d01c67829bcaaaa71b701781d99ddf"
  end

  def install
    libexec.install "db"
    libexec.install "bin/"
    bin.install_symlink libexec/"db"
  end

  test do
    output = shell_output("#{bin}/db server add localhost", 2)
    assert_match "fatal: Not a db repository", output
  end
end
