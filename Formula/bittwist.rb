class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.3/bittwist-macos-3.3.tar.gz"
  sha256 "2d9e65eefc1d2f05bcbbde798677deebc1efe059def76bafa7bb182ba826ffe2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cabd517fbfe398e28170cb5e10dc249d1bf2922152447dc3fecbb338d00a0e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf67b7ed06e3b32fce738f8956dce1df6ee2a05e9638236284d74fe37fb3876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d48986a38e0a2cb63f649b9dc6c2f26a7e74d8bd5272cb406cd367585b1fbfa"
    sha256 cellar: :any_skip_relocation, ventura:        "c71b0065250d7538a23cc6b1f8c6653080f2d3ae31ec90a26aefda3f4149d8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "31afb2cab1f5e11643c9b66232e572a14a14eab5b6dd1acdd5421723b1c6800f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0e2639c89a3c6c2d4297135a1fe6bd7cabadcb26cd32a0d302e1c69b768faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6827b39b34c431cc5c6fd87558c7a05cf50b04a209df3080b00e55ddb7b1bdfe"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
