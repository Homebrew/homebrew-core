class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.23.1.tar.gz"
  sha256 "9698919689178cc095f39dcb6a8a41ce32d5a1283e6fe62755e9a861232c307d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eefb530b176b9a06c00660d21d0c451f7c85be4b921050b47cff041a8766fb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a64747a179d32a3b25a60fd5983bb521f206f0a9e1ed822f74384026676be6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ece545c19380ba3c26bf5db30b25a9d5f77dc695d3a61887bf656267d7e7a72"
    sha256 cellar: :any_skip_relocation, ventura:        "38bde1557a174ab1b066f1265798fdc86e598fef2e54e238a01254428c185817"
    sha256 cellar: :any_skip_relocation, monterey:       "5872d5bba0ad3f1a2b0587542e2d4ccfb48a11f3f49371e01127fe6cce1cc7a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "03d625c493b30d412310289ce07ca803a67cdb872335bc9f8f3150e98a5c88f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a848acf2b41f07b816dae92b3262697e88ef20fb910268c6c7c36f32b4c3fcf9"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

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
