class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.3.1.tar.gz"
  sha256 "b1c5006edebaad3e2e286d12f70d136bf05658e9e8bda8d67ef7c477322a1a47"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18e41361e9aabcc661d067201a8833b63fbe49e8727008e1ca90ecd482ab71b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "690c2ac907040b2463b56df53423fa41b09d383a4b5019c24fe8797b17e56b2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef675752856ebfd976ee1db8411a7368cdbf5c1f009325e8aa1d19b554b327e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1cdd07c304ad39d3c522c811d36196e911a5e6fe89c736f1fa5f46795a7c58b"
    sha256 cellar: :any_skip_relocation, ventura:       "7049e2e4c58bf4a40bf002f74e19e7201fa2ea806cba87eb13934af4849d0873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091b84ae00c4fe6cc017fbd4730e32f2699dceba70491456fba29c6687ccacc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654016fe83fb602354bced323d6591b9a5a8ce2d48369b13cb17d32a4ac8305a"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
