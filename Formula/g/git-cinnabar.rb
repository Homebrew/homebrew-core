class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://static.crates.io/crates/git-cinnabar/git-cinnabar-0.7.3.crate"
  sha256 "18adcda45eeb4a1e82f28f404f788ed9051125c6fd760e468fd2763f17dd6cfe"
  license all_of: ["MPL-2.0", "GPL-2.0-only"]
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98719735b1336e7563142bc20589c09a0af0c2a85cc800304091d6820030ad90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22781503e1834d87080a9eb1144c33b2d1d8ac1268a51412c11b18f39e09198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd57c5c697df952beb5870fc8aa3395fd3445d68718a7613028b9c25db4900b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "96078ff2f74896e23f8cc90c924e588dcdd7d8ec27f3415789048f2746872502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a88ba4de45ce1ea571ed42c04b9db49dba009361d2a9d7728b8dc8903f1bc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249044e3aee1d59c56b68391ff6963ecc65ff2efae0cda8a9df5adbeadb0c9dc"
  end

  depends_on "rust" => :build
  depends_on "mercurial"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build # for curl-sys, not used on macOS
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
