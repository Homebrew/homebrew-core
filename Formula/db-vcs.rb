class DbVcs < Formula
  desc "Version control for MySQL databases"
  homepage "https://github.com/infostreams/db"
  url "https://github.com/infostreams/db/archive/1.1.tar.gz"
  sha256 "90f07c13c388896ba02032544820f8ff3a23e6f9dc1e320a1a653dd77e032ee7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53008992773bfb7066685792607092c21fd06f5e66818afb7d3c9bd60dfd0557"
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
