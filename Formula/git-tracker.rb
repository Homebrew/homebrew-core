class GitTracker < Formula
  desc "Integrate Pivotal Tracker into git use"
  homepage "https://github.com/stevenharman/git_tracker"
  url "https://github.com/stevenharman/git_tracker/archive/v1.6.3.tar.gz"
  sha256 "8864f4a3699c32ff56b3131bfe809a81b7446b2610cf0896015ac49a39b039c9"

  head "https://github.com/stevenharman/git_tracker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46aa6bb9caddfe0bb589e73132b67e5f9cf5558203ca276f24d994fdafa1327d" => :sierra
    sha256 "9d04e96e283ae94ea0a789911aeddddd55d53af805313ad6bf8b1d84334daca0" => :el_capitan
    sha256 "26afe6cdf02f1bda66d2d56518786970c8c1de878e00c09cb045cfbd3379487b" => :yosemite
    sha256 "132caf19abd7bef677b3d74f38e7fc5d139e90f03b4cb96c3ce8e34ea8cf96ad" => :mavericks
  end

  def install
    rake "standalone:install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match /git-tracker \d+(\.\d+)* is installed\./, output
  end
end
