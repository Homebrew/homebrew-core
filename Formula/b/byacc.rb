class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20260126.tgz"
  sha256 "b618c5fb44c2f5f048843db90f7d1b24f78f47b07913c8c7ba8c942d3eb24b00"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b744045116e9ce0829c9c99ed2df820a8b35a56e92be4e8f714446e3bd5301d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e605969cf2f5dde984d0087c2b8929125ae22b1191f8d6f5b5c9e53334c153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afd9bd2cb0d3f317178fb231f14e40e3a6c3d080b69cfc74b3e195eb53862f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e73885e9af6a04b10c8c0690bb278798114afa308e16edf73f4cc4a6df2070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1fdddc149a80df3d04ce5b80603a8845621e68bcac3dd6282c864944660f9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135f6821d7a1c90f3d5ca46dec5d53baa5ed57435c83ec545480c7e0d318d1f0"
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
