class Hexapoda < Formula
  desc "Colorful modal hex editor"
  homepage "https://simonomi.dev/hexapoda"
  url "https://github.com/simonomi/hexapoda/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "084156e55ad64bff5e43011fe58eaf588bf97da3f1e849c75d92821d8326149b"
  license "GPL-3.0-only"
  head "https://github.com/simonomi/hexapoda.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0117efc2f1230cf5633e23fee608e18c99d47ae33de1d98401aca60dba21ae49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac724c6d3e6e158c6208a8a6006afd1c45c5252ccd94f72bd2fab38b047c0b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c45a0d4b07453a89082ff3a57dd8b05ae2d942fe727682c0b19c107d476bd1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e626bdf04765e42513dcf5dfe181920a0714833cbcb8cae806f6cccddbf8fbf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1df6bf55b780a9bffcedc45e94c052372e73c42ccba1926ab2252e8e444e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a649b455fdf164bd84b8ff8b248be5ff19761a876d300105132221ec815a1a"
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
