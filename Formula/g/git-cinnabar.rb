class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://static.crates.io/crates/git-cinnabar/git-cinnabar-0.7.4.crate"
  sha256 "e2ab2733835fdc77f978814ed919f539bbd785b2c0d8e5bbb3ca5a35ef642d49"
  license all_of: ["MPL-2.0", "GPL-2.0-only"]
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9610b98370409f73bcc8426e5efcff7ad8b731dd427f0b5150c433440fabd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6f6a7d5fb70f964de07af170d7283436c85e78ffec77b3d980970e2e1eb751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "102e5de66074df517c80a4115b92508cffd25b5bd948fdf05f7a1d80017f5d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c82e58f99fa5b1502c7e1800cac793a8f6fe60bc7e51818d09c4d2bdb8bd20e"
    sha256 cellar: :any,                 arm64_linux:   "da53d18385ea9fcd4403183fd0c4acb7d7f4f816b6138e90d8c125e4e07bdba1"
    sha256 cellar: :any,                 x86_64_linux:  "49c5cec419698c90ed42c5442e92ac6c31628a6a78005d8c0968c379d53e2d89"
  end

  depends_on "rust" => :build
  depends_on "mercurial"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build # for curl-sys, not used on macOS
    depends_on "zlib-ng-compat"
  end

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    system "git", "-c", "cinnabar.check=traceback", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_path_exists testpath/"hello/hello.c", "hello.c not found in cloned repo"
  end
end
