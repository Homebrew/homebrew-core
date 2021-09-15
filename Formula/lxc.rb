class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.18.tar.gz"
  sha256 "b60e09e4d349eebfedff8f1ca493533fb7353aceb43cbbcd7f4e340715a5f3a5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72475f25c36703390972aafd51a9f26f1706c55f2b04f432143cea4a710ac9fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b8696d99622f05e6b68093ed64b87b326205c78ac4911d43b530132590e806b"
    sha256 cellar: :any_skip_relocation, catalina:      "2363f4fcc3c6b15787013d6e5fb14ec8810e4ab3555c720efa4471c8866e129c"
    sha256 cellar: :any_skip_relocation, mojave:        "18dbe1472fc07303f0836f47eb8175e31e7d5d00bfb773cf95fb983a7f7d2323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ef7a40a371de76fb0e61e1c897d3188ce7e2d4a648beb81485d12e1500f8c9"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
