class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "120935c7e98f9b64488fde39987154a6a5b2236cb65ae847917012adf5e122d1"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1bd66cf4147ca72261c46bc2ccd83b87ba439ae94b08f8341acad2368b970d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8b8fe68defcb12b13129f043232501c7b26e26bee95d234af007f7efb3a74c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "052713d1eb533cc327634f2af5b8b5c5cedd81e6d4dab490f01d27027f7bcb5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a932036d16254f460ca5eaf97ebbdba0b8889694948cf65c70463b1dafe8bd02"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b0d22a1df5991392d2c8ebc385d218681e42337610ac80bd53178e70dc7cfee"
    sha256 cellar: :any_skip_relocation, ventura:        "1d19910facdfecda3de68de5f171136aff02d5c4877f5c1b261f5718510d7eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "ae4f9d76a5f1ac4936289a0623c4ab936399ab4ec61ae72c32875c087ff62ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85322652128256141215d105d140346170a1748f789f0284a56c3f2568d6165d"
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
