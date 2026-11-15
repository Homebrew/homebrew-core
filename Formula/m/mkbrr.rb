class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "a9056b74dfe805890a7b629c9aa642297909ee5d8829bbae2594d957ef6c72f1"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a30e2bd08fbfc611a816ee5b5f8aaa02d3e81422e9a2e874b22d27bcf133e6fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a30e2bd08fbfc611a816ee5b5f8aaa02d3e81422e9a2e874b22d27bcf133e6fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a30e2bd08fbfc611a816ee5b5f8aaa02d3e81422e9a2e874b22d27bcf133e6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "24ffffefdafd21984809f1fc6e9e9b38cd311e12b31c91742775be29026db572"
    sha256 cellar: :any,                 x86_64_linux:      "0e5ed032b95379d6195317251396a9290c100a7dc2dd1851b9e5335668b37d02"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
