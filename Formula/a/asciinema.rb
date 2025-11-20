class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "612ecb265ccb316f07c9825bacd7301fd21f03a72b516edd370b0d3aa1adf2bb"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9411ff190cabfa8ca9a85555362dd5311a3da03061aba49bd42e86dac6cd5222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f52a807a21b826e63ec4eeec391d0d1acbe9ac0d2041e70d71868b1d1900c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1e2fd482ea5c1437fd0b087bfa931b1e165be9a4932e313eed3964d0f928c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ce98155a854b9c7d3d95f156f66a8eed5eb2868c4020283da8e023ad81e7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37ea2aec4888cd4a0e05e1ef398dc6d805dace1b88567663b4ad290cdf046f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72947fa454d14cb38785b507462c56724a4c97ca218d5ebafdb3825c52321912"
  end

  depends_on "rust" => :build

  def install
    ENV["ASCIINEMA_GEN_DIR"] = "."

    system "cargo", "install", *std_cargo_args

    man1.install Dir["man/**/*.1"]

    bash_completion.install "completion/asciinema.bash" => "asciinema"
    fish_completion.install "completion/asciinema.fish"
    zsh_completion.install "completion/_asciinema"
    pwsh_completion.install "completion/_asciinema.ps1" => "asciinema"
    (share/"elvish/lib").install "completion/asciinema.elv"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
