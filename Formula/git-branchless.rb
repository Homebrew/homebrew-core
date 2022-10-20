class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "a79e5a63ef0322defe5b918ed62d576d30681b0a16b12e57d6b5ce17096bff4f"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbc8bc603e716d8eeee574b15e24a3c1bab54e2c90513a97095081d6f67b616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d7506dece1acd940a882d6679386351bef5ec3bec259370249a9c4d1703109e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e7373546f19bce2386ef60c04f66bd05fb5818febc11014260dfec64a0bdae3"
    sha256 cellar: :any_skip_relocation, big_sur:        "21cc2ab14bd209b131e868076a959f50b7c3a3ca18ce30aca9b7d8bbc7862e89"
    sha256 cellar: :any_skip_relocation, catalina:       "bcfbf85d7623b28b891bd2b812033e87484b3783a1fd8b5158f081db7e376bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1b3e8702efbe09187902c68e45aa7037725892459e4b1efa61ea044faadacc"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git-branchless")
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip
  end
end
