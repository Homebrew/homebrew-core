class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://static.crates.io/crates/git-cinnabar/git-cinnabar-0.7.5.crate"
  sha256 "b7f51bf94f7795deb25b862c72a57f83c48f84d12e52c20e5f99f6c70397a516"
  license all_of: ["MPL-2.0", "GPL-2.0-only"]
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "231d77635690a2da599202a1a6b14631919423adfec5f047b8ffedf8dd3f063c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebb3d2ad35aa9568d16389b36efdb688105e5b1bc5c5070b8de0d3ef67b7a50b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db5c9a7a4baef75c24d8592d0a052923a9d801be68a87cb71b98fa64c8ec7ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b9e72e57888da6c388728f3b65f6b2b34ba99c9578fdc9a68118b317dac3b3e5"
    sha256 cellar: :any,                 arm64_linux:       "0392caacbcb5da3296da21bf92941f5ca3d8c48092dfe124d71db1adc488a52c"
    sha256 cellar: :any,                 x86_64_linux:      "ba11bac0d78cfe8e36e7c641856085889d05b15dfc3b2ec5993271b2527d14ed"
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
