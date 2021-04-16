class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210328.tgz"
  sha256 "8b8f258eb22a4eae994ee374a712dd08e023cde1c39b373e8db8ba7806c50585"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be4ed7e396441833b8b78810ad409af5eb9f46aad11afe31f289d288e5a918cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "041c1b96c3fd1815773852b0bde4b02299b38a07b3c88f6241118272f7ec986c"
    sha256 cellar: :any_skip_relocation, catalina:      "e14682e1ef9fbdc9c8ad4d999eae995deb9e1130d30383f065aa1c2ca9527dee"
    sha256 cellar: :any_skip_relocation, mojave:        "0bf94e42d846dc2ab79de8e9861f78ec6c372a07c215ceaa39e424ce45931c9b"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
