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
    rebuild 1
    sha256 "728ebb14408ce469fa4920a0a3bf9fb27bf84f90f6d16da494cf3f34c6a5bb97" => :catalina
    sha256 "9bef54033f1bc1b97a3bed0410f0cc28d40be9ac236211134ff0530d27d12b8d" => :mojave
    sha256 "dfa0c54e4a0e4ace4d69bfbea2b19065deac6271a7f564a7379e6a5266d96dbf" => :high_sierra
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
