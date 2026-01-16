class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dae8d43087686a4a1de0584922608e9cbab00727d0f72e4aa487860a9cbfeefa"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c01d278f44b6891692ae88f84fbe752e0e4ec27e91208e7072347bf12df4d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71df1a0998e3e4d3807ed08c141daf4a8b868e8c65f3d5976db322063220f59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42dab364137a3b7d21f93243d0174ccca4ce02122936667502573ec87bc4a89c"
    sha256 cellar: :any_skip_relocation, sonoma:        "289a05801f1b9d460c6b292b6a98bc145565ec8b0e643196125871f8d6f56ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35ce6bdbf4752cf4f361d4c7df419e471ba4d6f01a02e85265bca6b302b3b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69ee006a151ae3153e3b0baa1b7a27f845baca011a58f4156e9a6761e3ba56d"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

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
