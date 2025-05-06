class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "120935c7e98f9b64488fde39987154a6a5b2236cb65ae847917012adf5e122d1"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620e65bedbd524277a073f2469d5467c7e93e88a95c227da58b5f270966392a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "171fdc624eada5c1f48837e56e5f0a44139fc897de8b0c75a6637b64cfb41b87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ab10dba6606d09d98086b000a07ea2c6d0573e3b6e4ffc4eba3c30260810c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a078994599902b8b972d7bf4ce14ad755a0b559f7794e08ad9e40110c8365e"
    sha256 cellar: :any_skip_relocation, ventura:       "2cee4fdf553f67937d3df1bdbecf420ea9453de347a3b6f99aa0a03f28020063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e1d07af95ef7f56c3ed463b32df4470de95e42eb274af7678ab6903f81108e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5e2e98f824400895e34655adfbc250a3140e304a0247d11a4e64a9e2c133b2"
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

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
