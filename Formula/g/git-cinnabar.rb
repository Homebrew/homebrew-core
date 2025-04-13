class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.7.2",
      revision: "1975d040654a4f015456eef6869e40d32761d083"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a241ac1a64424dd93ba9794a5319f1bedcf64fc3c028e3e89ee7d6cea60e9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95e69fb7a618b4bed2e50649d27db679169fed3eccb16676c7edf17ba4ffda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "675934ba581d5911c174970e37886d46791d36baa49f4e73251ca42673a73b91"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f148aa44537226a43200dc72ab9493e7adce2170d0d972191a5f5d3228d253"
    sha256 cellar: :any_skip_relocation, ventura:       "c85802f34296425e635bf069f74f4eba5bd960aca294df2b0cfc329ab051e842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f24f9a2e493c0f4cc251f681b993072df26e04ebb9174eed029f2b8877c3e6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed2073510084eff7527436e382ca7b833384b145e0c786b3fe8d002ae0a5402"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    # Protocol \"https\" not supported or disabled in libcurl"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_path_exists testpath/"hello/hello.c", "hello.c not found in cloned repo"
  end
end
