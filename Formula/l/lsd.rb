class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cd80dae9a8f6c4c2061f79084468ea6e04c372e932e3712a165119417960e14e"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb9f7bc8aea8231ad150e829a43eec918fec6fd1c0b53f0c0d7292ff96432f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c529215209023473a75895082ffec3e51291559d97cedb20d8d3cada085251a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c328dc58a83bdb82f1ff8ac175b1b145b630399041c541199d5e6c009e13b431"
    sha256 cellar: :any_skip_relocation, sonoma:         "bed44b96025d6fb3a5c29f7b58f422e889c148c2d4ea7f5574de59290207feb6"
    sha256 cellar: :any_skip_relocation, ventura:        "72117f112c6d3868571f2354353cdbd4fdadefcd6b93e13d50d43ce9d6852156"
    sha256 cellar: :any_skip_relocation, monterey:       "495054e4b9b60d14c403c9114117a613b796c5e98f597fbe4093e518543c9a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b4dd76450606fbabb81a49fde2042772cd512eb41553eede8fccf230bb6ea1"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
