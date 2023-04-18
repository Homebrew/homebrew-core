class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.23.0.tar.gz"
  sha256 "30b6256bea0143caebd08256e0a605280afbbc5eef7ce692f84621eb232a9b31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8177a3ddab18619e77116cbfe59d4d2c03a6aaeba042601390a92d22aa08a46d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "276919443822ce3cc55843e43843b811cf8db79dcc879d287158753ec1cd4075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8433bab46de75d78ea184a79662a74c8fa7cc087236fe5b29f1a48f5d06c94ed"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff93e5f116859666cf9f147d90c06e0fe53b80d31370b20f0f123ae322f68fd"
    sha256 cellar: :any_skip_relocation, monterey:       "863269989acbd5d931811547313b6fd98f9acbaeb483cd254ecf418b9d19c4f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "28aba91680d3a12e54157f6ee7dda049198509a0a4bfdf14a44248a4a9597022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062b61c453c47e891a03cf9000b319d30f71988acd4b9cd8a083071d0f831028"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
