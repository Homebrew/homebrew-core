class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dae8d43087686a4a1de0584922608e9cbab00727d0f72e4aa487860a9cbfeefa"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa8f25c1284258f51c9404613e9916de94bdddb03cbfad25035f31b744d5f783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7425ca72a17cbffd1a2b25e6a123d94262716e4cb1866901ba4a65658285c503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d4ce37db61b448e6f861e44331cc881772f12daafffd171c744c86371cfa52"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ae6b9716b0c8313085cc09de1ed5a493a639fbd04a3c440b0f356051f077d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671174793531f94debdbbe7fb1017e41a070b99a3e0556eb7424bf06fcbf65c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb617c2546080a6164e9badba18fdba7d1e1e6692168e15759f34d05f332765"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash" => "lsd"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
    pwsh_completion.install "_lsd.ps1"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
