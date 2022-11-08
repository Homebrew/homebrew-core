class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.14.0.tar.gz"
  sha256 "7d1ab2949d00f712ad16c8c7fc4be500d20def9ba70394182720a36d300a967c"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d24d6ecd9922864f3eef1334fe7f24dc73887213260766c78828b35bc90c8894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5d5553c08baae261526a1692b386d3a9e099f4532e1862941dc9cf5a1f131e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8c1019c286aaf55ed1a5b1258660c2a4c3998e4495dd0a77f49f276c05b7cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "a2243ed55cac8ad9c315dd71b7f77ae237f9908c540de26406b6743ff7ba0f27"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b9c8d8509ce9ea4a2dab46654f8dc3ab64284d302eedc5f9fe792f401b0f000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8930e0612d145d5bcfbc5c626707400f94c841425e86fc5dc43fa1454ca5121b"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
