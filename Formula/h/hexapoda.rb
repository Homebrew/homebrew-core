class Hexapoda < Formula
  desc "Colorful modal hex editor"
  homepage "https://simonomi.dev/hexapoda"
  url "https://github.com/simonomi/hexapoda/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "33c57a7bfbfab6401b94ef369262a8b8a9cde53371b032bb5c630677d26b0940"
  license "GPL-3.0-only"
  head "https://github.com/simonomi/hexapoda.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f2a7f637ae2e7c192cea4055d3345a784c02f28c6a24d2d2e708841c96e867b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e55f1e1abca45d4cc1b981ae98dca58a42b4d35706e43c6aa4013cb617f54d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d03b5412376719bfceba00f689d3cb171b33d179779c338d10082e2bb1e211"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a2255cd41d92346869109ba454b5048bd151e67cdd111de4d09a6b098a9257"
    sha256 cellar: :any,                 arm64_linux:   "933771b265105b98e8e93150b199eb1d882b628653b71fd30c15a4cbad66a595"
    sha256 cellar: :any,                 x86_64_linux:  "4c6db392dcbd881e39485a401ed61340fb6414796fd20ad2c3a44d15fbe77f13"
  end

  depends_on "rust" => :build

  def install
    ENV["HEXAPODA_COMPLETIONS"] = buildpath
    ENV["HEXAPODA_MANPAGE"] = buildpath

    system "cargo", "install", *std_cargo_args

    man1.install "hexapoda.1"

    bash_completion.install "hexapoda.bash"
    fish_completion.install "hexapoda.fish"
    zsh_completion.install "_hexapoda"
    pwsh_completion.install "_hexapoda.ps1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexapoda --version")
    assert_match "hexapoda.toml", shell_output("#{bin}/hexapoda --show-config-path")
  end
end
