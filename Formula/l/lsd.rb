class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cd80dae9a8f6c4c2061f79084468ea6e04c372e932e3712a165119417960e14e"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "027e3ba1d73615e16a1a74f12733841d36a32cb131a8657fb96d8ece41fcd5d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "657cc7ac5bff7861461b767f269fac518ff4af0642850f76ff8a797577b7d5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4109de20c64864e6e5fdaf9ccfbbf7f548eb61226b6051b6d55ce045dd34a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "62c1787b634e9cb9728ea4fdca9d9b8e5e87dac1d2938c2613ba0264f2fb62a2"
    sha256 cellar: :any_skip_relocation, ventura:        "90c856e0277445914fb47e0d7d1e020e69e7cd72a675e4f73765a284d79ec924"
    sha256 cellar: :any_skip_relocation, monterey:       "f8216e4e7492f603eca16d736209577864eadc20932cd9d4e5749836d14acc39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31de828a654365884713c54d7177791752505c4e01b8b71c0bbad5215772c85c"
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
