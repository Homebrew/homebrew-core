class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20260426.tar.gz"
  sha256 "7ae5b9fc6a8149bc45ea0ba3ba434a69a16d1460d19f6d01b6f04cc885b8e02b"
  license "SMLNJ"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3661f3ece005a2b68de7cdbdc202f986cc851e0840be63b09e0c247c651f4782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "839ada88bfb7cbc5f89fe6dca83c80a4eb81265521630f98e6d6cc48e4e5c1c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67e546df7fece3b3d1c4b6d7560da411deb078556d66789f8d0d414f4ae339a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a14e837db57634faa6d83211a01186f0430e0bc763aa7dfe5071ba4b6bda69bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a3b73db12b9c18dbc671906cca7202b94bff36af3a76f9d797f4a4f7d41a98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4434db0cc9a0303dc2c127eaf75117890297a8dcbab9784fbadd09d0952779f0"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test", 0)
  end
end
