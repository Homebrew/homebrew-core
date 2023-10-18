class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.6.2",
      revision: "3b763ba9d1a7adfbbec392a72e802bff3a5a245c"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a92b2ecc47fbe335a6a594bc3567920ab8c03f4d95dbbfccb496a0472049ff61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c668ff3557b13a4f552e954b0ea99506d326a7544f8927df1d8daefb76298e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d385e374295bac7baf44d7924980b46dcae579d80634464c3eb49a195925c210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "477f14056ad207fe51536fab1056bcc27052f15467d421d81dca3f4c413d9572"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ceb51b19574e5d0460a73751b0c984df62d1d1e69921dd6d8092d61fb939ded"
    sha256 cellar: :any_skip_relocation, ventura:        "ae256f9873a276a6b894b4f058749620f71485e643f48baf270ce03c8a1c4cfd"
    sha256 cellar: :any_skip_relocation, monterey:       "5793f2494ddc9e2d6875adfc95e6f120a6b22140830d1f7cdec3849fbb44e534"
    sha256 cellar: :any_skip_relocation, big_sur:        "de90bc46344f545aa8480ee993518754c0df9f7a4c7c87e21bcf5156e4c299a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5e94a86d07b49080d8d6d4ab671731d3c5a430fc1abdb84fd96eedf1c4b8f9"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    # Protocol \"https\" not supported or disabled in libcurl"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
