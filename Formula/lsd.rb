class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.22.0.tar.gz"
  sha256 "30ad1b1d014c7b6a2fca44c6de3b17198c84168d34fc946245d67094ebc0f7ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc1de78c46f77bc78271edc72f5b686752ec802994152e04bc28844cc766885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865b74b3c8cc56659b6f45405246c5fb2fd77c704f3589e9c264b19a77b19695"
    sha256 cellar: :any_skip_relocation, monterey:       "17baa9e9966cdc1b09f29d184ae7c2e7dc8a80ff16a6d912e8cb7532c1fbf45c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4201d2af7a498998975acd8c509597097b785781e02fc648f5013edc32f379a"
    sha256 cellar: :any_skip_relocation, catalina:       "783710c24dba95a94cbbc7cbef3ca4d99e7d6d8249453b7b2d4ad74cbdfb622c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6fe786f3e491a193bd8e14e92f6483367b6e8849e34dec4dfd21094b22cebb5"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
