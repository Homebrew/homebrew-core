class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "https://cyberelk.net/tim/software/patchutils/"
  url "https://github.com/twaugh/patchutils/releases/download/0.4.4/patchutils-0.4.4.tar.xz"
  sha256 "2008241ee5d4f87ada3f743c719cc010b0ba929126e255f23c3fb48f614c7e32"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a163bdf8c82bc4bc946e94976d8179a3b57ca8164ca778898e927cb443f3167f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383672e0d4f49bce8347bb81a2f474d6d3c3bc130d9e375b48173c00f03a7215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248da7e0bdf127e9634329ff87a9033780fadbd47fbec5dafd253fdea3546e5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6025e477cef67fccdb10eaaf15b09158d1638f6c9713e35e09a3f011a9068b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd43fdb846224f2e3b453172da0befa23bcd1c4ed78c09529242dacc15dbca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1f74bf22d1e002dd4c471d98442be15151c0b71320cfd887c9a75ac7ac735f"
  end

  head do
    url "https://github.com/twaugh/patchutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match %r{a/libexec/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
