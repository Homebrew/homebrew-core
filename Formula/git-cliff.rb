class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "b77b0c0d999b6d5fe6a175ef603c373a72e0f197b45833213c1b97758b1b7a3f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dd717ba4b671985e3de4b3a5a50d4c311b3cfc67b78a4d3afa78cff787c1d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a570a05b74c31c0525cdd19c1d2729053c36b9133a4fddb364703ce8d53fa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d03af85ad34b59a96777f0e546a491749822177db3a63bd03813f02ade5008"
    sha256 cellar: :any_skip_relocation, ventura:        "570dd888952cb29d7e7b72f848fceceb48004ef50f9fce69caec979cddb8e30a"
    sha256 cellar: :any_skip_relocation, monterey:       "17562afc8380d63a80d984f6a80470bcb88422c89f58c75bd7b1e0429996f374"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba3c9ad3c068fd6b16fdc69218ebfe824eae044eefd01a9e8dac28a1bc6ce3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1123490dc0fcd99b7dde8996111776fd66ec862be1bc5557c2bb4e771611730b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
