class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.20.tar.gz"
  sha256 "35504ef2e2dc7024b7088010987657969b1e2dea5581b24b4294f8f449248ed5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b45c85faf3771083a8f452fc5ac61e76f58bba74be0d21cc631346e9030c1377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fbf94307ed09f5283ae28ffa69396cdf3cce144a5744781864c5f0041ce5222"
    sha256 cellar: :any_skip_relocation, monterey:       "5b30a6b7530b528d7fc9da11a48b5ebf0810757acd82ccea0bc9684f34466234"
    sha256 cellar: :any_skip_relocation, big_sur:        "d246824961d641893fa212daa7c078e0e4dbc5a7167da0911f25b9334dd4f352"
    sha256 cellar: :any_skip_relocation, catalina:       "b2f3e1c8114b2d344fa9defa5df340a42c945f5d4222a571968951079223f71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03927c037f8d5bc9d08d93ddce1a9a840bf77dc8e0d2b6b949ade7e9910c3bb9"
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
