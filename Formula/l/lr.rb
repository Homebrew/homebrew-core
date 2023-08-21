class Lr < Formula
  desc "File list utility with features from ls(1), find(1), stat(1), and du(1)"
  homepage "https://github.com/leahneukirchen/lr"
  url "https://github.com/leahneukirchen/lr/archive/refs/tags/v1.6.tar.gz"
  sha256 "5c1160848b5379e2a51c56be5642b382f4ba2b579b7f43834c80e6d856c09b10"
  license "MIT"
  head "https://github.com/leahneukirchen/lr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501cd972976041e65e066e2fcd49b0d6be2627ca686e230ee987dd3042bb3ea4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c380adb162fc049ad50a96ea2277feffefbf014d3038b1ce62190bbbd6fb08a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e7b1a762a2194579ccff17c52b287b69f59162d6182c7c84ef6859286f4459"
    sha256 cellar: :any_skip_relocation, ventura:        "b6497f9afd4b1f50b47399ea5d6f82e8bacb4e890b861d07f6c57a113cf7db16"
    sha256 cellar: :any_skip_relocation, monterey:       "829cf70a931246edf6f238bc929ee9381eafb41aece7d3017ca402115fa0e6d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bce6806f73a80466046ae85376607765322c51e7e3b9296581834c2135b743e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f26c65c91cd102e17c2efdc919d67ba4a65c44dda54c47faffb2f3ca23187e69"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/^\.\n(.*\n)?Library\n/, shell_output("#{bin}/lr -1"))
  end
end
