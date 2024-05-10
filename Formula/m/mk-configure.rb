class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.38.3/mk-configure-0.38.3.tar.gz"
  sha256 "c6b5dfdca304eb9462f7d61f94f591844ef2a1ea7c0bbe1397eeff9c9b912afa"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e3eaad03df69e5184e6ea7afb922d7fe0e4314b45db877dd6bd554e1be44f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eab326a7e545c3bc9eb7db353d1661f6af37281b0c99cd3b37b432156f5bbe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c7fc5403cab7c48eec3e14248f4f8e762f87b0f8245e72fff48cf9063bbf7c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1de2d66c2112108a0f334f131e38c24d5e3dfbd9ef2500ccca346fecf01f0405"
    sha256 cellar: :any_skip_relocation, ventura:        "af0b96e1776cae5c830478ba53d1527f34445ca9e415ee74513c0ed1c520b140"
    sha256 cellar: :any_skip_relocation, monterey:       "ae839243ef4ae026fcd8f9005e40e857999f33549273d99ea208be550334deef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9b6ece260aab02d39d3a28ac42ca04e91401ca254acc286c6fb4a7285fae48"
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
