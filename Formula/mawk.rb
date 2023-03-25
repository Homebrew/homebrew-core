class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230322.tgz"
  sha256 "cafaa642c6d738484dedcb24e8433bf57ff1f7ee958cfa547603e433135d9d89"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7062cb7ea3e033bc13bf818e8673bf5ffdee23c66c678c5d6a54290f982b8a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb872d916390fd8bf0c5505394c5c86eaa3390f3272c67fab1ecd9a6c5ddb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f0f2488614f950858263e98528ffd1b7f8d97f5860d4795fb9eb4d3a49612d6"
    sha256 cellar: :any_skip_relocation, ventura:        "56c993944d64f65b12e44546e7a93a7324a0e15da78fc01484f354d32b17129a"
    sha256 cellar: :any_skip_relocation, monterey:       "0bacbe664e81fa408092c9abae2c01ef1680bb653d896336c52a496874337f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9607a5e08c6301576e62cf36bcb6e88b7d3a0d72d9951bd040e3703333645a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832990ee932596b58ee42e757cea48ceca157a6a43120be7b4340b5a6aa301b1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
