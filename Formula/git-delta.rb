class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.3.tar.gz"
  sha256 "cf68f43d4d26c10551c0137a7e718719958e52267d83f29a8f7794af12095b9e"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38f445182717dc92fb654871935d936ee932baaa49617a3a217325a4a5a8d033"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98e71c99827e083aea7fde4edcfbe11bc9ab5b1bff8731f8726cc9ad70378c40"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd9f1eb9ddca369f2b1792c7a74ef8086fad5758d28c9fa035e7f0fdbd1c414"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c046081a409513ccf0d871b6ca6f26be882d95b691f735da74502fa2ff6ee21"
    sha256 cellar: :any_skip_relocation, catalina:       "0878dc6e9edfdad87d5caa270869da90766cca1ce91a4c0abbf3f12c53c24c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9ffeba04833087f884c88ca779f909cb42ad2b0741d504d0adff3f022db13a"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
