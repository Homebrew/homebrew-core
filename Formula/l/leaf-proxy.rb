class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e606d659d0a380c4c32b97d9d4dec8e4773e511b30be52868f34401cc1682d4c"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4931377471eacbffed4eb10b72ae3b9c62501d19c81bf8b7f180b59f3dd6bfcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cfac0702aa9869f020424de657a1d753b168fb9a3cfe22e5822b795393395db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd98538c676182f3408fc2c98f81b706917afd4cb206d971114f3f5d99a6ec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d90d53f005df82fc82e9ef38c400bf9dc2801b27a5ca8e41b6e50e11eb0927de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7043607cdcfe2f83320fd1c8133a73ef76b2fb4d9c09e7298e1627b5beac27e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b59f782b299202f082cd9988116f9c9d9596ef5a50d1bad1364829b8fc648b"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-cli")
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end
