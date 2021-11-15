class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.37.0/mk-configure-0.37.0.tar.gz"
  sha256 "16d66de82bec9f050d5641af0851171e4804be69095630a01f7af8b88cd199e7"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca9449aa389f16613661553243de67150d36b019d6b77b767f95c03fd0da1bba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99cfb90e5b63675ee36307557d4c4981843cb39f96824d3b0424d0feaa215ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c8a8dd1f1710a987a6417b3ad3972cb03461213148284185ea535a54f373b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "74fd29adec76158ebe619c4116609fe56b88aed78f64161fa352cad842a5a760"
    sha256 cellar: :any_skip_relocation, catalina:       "d49908536866ff5ad40d08035125236d0f3c0cdcb0d4db190b4d2fc72deee1c1"
    sha256 cellar: :any_skip_relocation, mojave:         "8e2d5682e9bbafe39e7d518b681f7e498b95b81a9e4ba16e5159af08825c2078"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
