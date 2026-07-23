class Hexapoda < Formula
  desc "Colorful modal hex editor"
  homepage "https://simonomi.dev/hexapoda"
  url "https://github.com/simonomi/hexapoda/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "3c205ee738d97743f48aa6d4190c3a2892766a07e7ceb80e09dfa5844c32a395"
  license "GPL-3.0-only"
  head "https://github.com/simonomi/hexapoda.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb97c2a7f0bfe16a8e94ca0c78f0de95f7f91d6f950e6a0e9098d3a234c6084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6878ce843993c8958260c4fe5ae8e59b7f73aaf2f7e545b756ee8070972105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b68c8cccb6bf38ad6ace18eee63d23dc58f7cda94be3bbc2fcc36f7e9f9b856c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6febd97bed182d764e05b65bf5d4a3830e66f22527770d9999f2a484f29f87aa"
    sha256 cellar: :any,                 arm64_linux:   "f830547ede3671c4287b427b082d732d9a0b4e26d56cd860400dcde529a1bef1"
    sha256 cellar: :any,                 x86_64_linux:  "42547cd79f7a0656094fef8ed918d33fd746c703e1ad1c97c7696930651240e3"
  end

  depends_on "rust" => :build

  def install
    ENV["HEXAPODA_COMPLETIONS"] = buildpath
    ENV["HEXAPODA_MANPAGE"] = buildpath

    system "cargo", "install", *std_cargo_args

    man1.install "hexapoda.1"

    bash_completion.install "hexapoda.bash"
    fish_completion.install "hexapoda.fish"
    zsh_completion.install "_hexapoda"
    pwsh_completion.install "_hexapoda.ps1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexapoda --version")
    assert_match "hexapoda.toml", shell_output("#{bin}/hexapoda --show-config-path")
  end
end
