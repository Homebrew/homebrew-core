class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  stable do
    url "https://github.com/mattn/jvgrep/archive/v5.8.10.tar.gz"
    sha256 "93b253a75a505bf0f58b23428b0aaa4bed842fe0060e282793066ee88d7672c9"

    # upstream PR, https://github.com/mattn/jvgrep/pull/81
    patch do
      url "https://github.com/mattn/jvgrep/commit/5b5a04d66d00c890bc263754bb5681fbe2f837a9.patch?full_index=1"
      sha256 "a9cc6518b6ea9e68e32bcd4f30fcb4a4a37b5df554306d27f24199f281bc046f"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3500cca592776298c3e931471df33ddd104d896132172ef65c3b23a40c97044"
    sha256 cellar: :any_skip_relocation, ventura:        "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a81d099a7a5124558df7a8cd3086ab9ff28ecbe2bbfa6d1efc76c68e993e0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f31884bb494544933b0764d6094c64bb6c830be1b57b1aac8621165ae7eb8f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
