class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://static.crates.io/crates/git-cinnabar/git-cinnabar-0.7.3.crate"
  sha256 "18adcda45eeb4a1e82f28f404f788ed9051125c6fd760e468fd2763f17dd6cfe"
  license all_of: ["MPL-2.0", "GPL-2.0-only"]
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b06591734734c4dbe34b9172cb62e65fb79b1349ec81b058eeba46e9d2e917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1e839b2a39b20a5aa8136e2be5686275a0cd0f0e3c58d2f9688b27c3c0b5e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc05fcdd91d94b52b65055dd953e476c26749d0062e8ddae14f1fc3e5ca1d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "71939c24c0359e4776f84468c34677094e7cf15a973cb126b3bc5fe57fa5d65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3538e386b2274c833fb1f902ffb2ad1c58c3fb4319d7f7ae8a6870e4a7775d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c274e3418ef3507c849e77dcf5ffdaf74bdec0c79f28b385550b5896f04151a3"
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
