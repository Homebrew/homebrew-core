class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.9.0.tar.gz"
  sha256 "96e743ffac0512a278de9ca3277183536ee8b691a46ff200ec27e28108fef783"
  license "MIT"
  head "https://github.com/ogham/exa.git"

  livecheck do
    url "https://github.com/ogham/exa/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "db91d6383734415664520fadb8a4401c465f08b6c8dbd5c56d47e959d04ec6f5" => :catalina
    sha256 "6c4473e06868d60a18657f8f6d98985ec7480de89213765738a3e33eeb9ceee1" => :mojave
    sha256 "e47d5005f3a6a05bc442ed8e12a8e3206f39d0e4daf4835e84545ab158c4f089" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Remove in 0.9+
    if build.head?
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"
    else
      bash_completion.install "contrib/completions.bash" => "exa"
      zsh_completion.install  "contrib/completions.zsh"  => "_exa"
      fish_completion.install "contrib/completions.fish" => "exa.fish"
    end
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
