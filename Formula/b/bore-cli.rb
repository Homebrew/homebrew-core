class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "https://github.com/ekzhang/bore"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "286e2f6fee4928912bfd17f9805e0da250ddcec2200cedbe7056697790bd3914"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a9473dd1533097677e95287b01988e3482e729c11936c0da964dd9982a0f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed4f1f198466c0e7bf5303fe3c59a896f468dc6f7df5500b8a53686263d0c85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fa3583059981011d5992aafc1ccc443d91c4be3b416f774191329b23904c71c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d54801caf21a2a64b64c705f65b7af8414da32ba63b52a93b32033ea17825810"
    sha256 cellar: :any_skip_relocation, ventura:       "a14f20e407fcf270edd729d3ab661a62ece9dde4488fccc2d21378d7801bdc42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6d1ae1df57064b69b50fac50825f6e4b0f225c4f0ecb404b50fa9fdbbd8174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b25e14702328c566532243a2eb102ed4f8f6d9112bedf05f8925c56c284e59ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
