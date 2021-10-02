class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.6.0",
      revision: "75969065e1c5b72c09afd69fc7f77b06cad07d0d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20831dfb9722dcb5784714763e63a440fd023707e45d56fce5ec5faccc7b7043"
    sha256 cellar: :any_skip_relocation, big_sur:       "58b6452ed82834209756faa95e804b63a3da7d28cc4ba5cf1ffe6202c714593d"
    sha256 cellar: :any_skip_relocation, catalina:      "d23d6d2c3f464c70aefa11e716c7fa7dbd87de24a8ff19acef9f69571b4db4ed"
    sha256 cellar: :any_skip_relocation, mojave:        "8aad68e69bd80c55bf3c5fe02e919c9d5c027382d39ae279ee6bc02675a800da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e764144e83ff9991d3ae1a82d773e06ad7ed82b60cf943c7611af0018cae37bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
