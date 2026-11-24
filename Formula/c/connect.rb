class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://github.com/gotoh/ssh-connect"
  url "https://github.com/gotoh/ssh-connect/archive/refs/tags/1.107.tar.gz"
  sha256 "b15bd4d63356b789dc18fa608acb1aaebdfb70caf49ebc9760b89a09f651fa07"
  license "GPL-2.0-or-later"
  head "https://github.com/gotoh/ssh-connect.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "6af70cbca67284eedda7e1e9a379582fec902b5447f7da675d49bb6a358f3209"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0acbf1bdedc68b1cc2326123f45be1b4e8ef256fbb4f241214a64fab55c7351"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f608c73d4cca81335f6960901ec2eb3144f8cacbde2daadf583e0ecb2d82139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dca592e0bc00026b0bb37ed6c750f4e76007927b50eca9ef122ac0933ea3ce2d"
    sha256 cellar: :any,                 arm64_linux:       "e09203456e82f1b0ad6e5cb2d86924b736f2a2106cba568aa4432ca69f359281"
    sha256 cellar: :any,                 x86_64_linux:      "600656245fe4d5159334aa95abed48524f75126c743d551688380d5f1789815d"
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
