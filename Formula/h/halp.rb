class Halp < Formula
  desc "CLI tool to get help with CLI tools"
  homepage "https://halp.cli.rs/"
  url "https://github.com/orhun/halp/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "ec074ceb472c4a85dbd321ef3928014d6ac2e60a23f2ef8055e3133ecd845b88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/halp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "845b1a13a6e9af898ff014d4ed91c6519fbac150ef7f1dfa7d4aafca90202205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ce882891a41e4dc4ca293ead3b7d01eb4b2fad57cb2b2513b2e8935cbe4e9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0ab6b981379efece5204560139c5a7c91bdd4ca49c244c2ac88b8f4868eecee"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf695d832c299486b4fc0609d66d8050f164415fb86d966797bcb0e74f23b6fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ad8e26ebdc55f290d8c9b734e89cfb11c3856a1b07b58f25c9703e624807fb57"
    sha256 cellar: :any_skip_relocation, monterey:       "eda52507afd62e7ed2d9007a725aca4a3ec69c271d2feba1d876a1f56adb5682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7cb64c843bcee429b3fd7e7dadee064a3803a2dc500f7eff674787e4ccd695"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Setup OUT_DIR for completion and manpage generations
    ENV["OUT_DIR"] = buildpath

    system bin/"halp-completions"
    bash_completion.install "halp.bash" => "halp"
    fish_completion.install "halp.fish"
    zsh_completion.install "_halp"

    system bin/"halp-mangen"
    man1.install "halp.1"

    # Remove binaries used for building completions and manpage
    rm_f [bin/"halp-completions", bin/"halp-mangen", bin/"halp-test"]
  end

  test do
    output = shell_output("#{bin}/halp halp")
    assert_match <<~EOS, output
      (\u00B0\u30ED\u00B0)  checking 'halp -v'
      (\u00D7\uFE4F\u00D7)      fail '-v' argument not found.
      (\u00B0\u30ED\u00B0)  checking 'halp -V'
      \\(^\u30EE^)/ success '-V' argument found!
    EOS

    assert_match version.to_s, shell_output("#{bin}/halp --version")
  end
end
