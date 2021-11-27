class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.2.tar.gz"
  sha256 "e0f71d72eca543478941401bd96fefc5fa3f70e7860a9f858f63bfecf8fd77a5"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2c951588dbe13ff28c555b732987ec3c8c1e3be188175bd6ae8f9682ce4dcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12795780503682d54814f065ac39c4c7438e2e5de06e5cfb21b1cedf41109691"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b5f24b9ea5f9834e878ecc4eea6c3e47b0fda2638015c600343af81416f492"
    sha256 cellar: :any_skip_relocation, big_sur:        "5439961e42cf44943d7fc7a4ebac1ca33f21bdc8c1da0772a094256661d7a0c0"
    sha256 cellar: :any_skip_relocation, catalina:       "1115aa469a95aee72a865cc6c868f4f678c9e9407c97cbdc73cc784a9231855d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba6cbb657e0c415073c142f8f0062714d602ef9573b4e814de57d3bd41a0893"
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
