class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.0.0/qalculate-gtk-5.0.0.tar.gz"
  sha256 "4fb840a42a2246a98db81431baf4622504a226b1d3cbbe36da5649926ad177a9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "e4660809ea96ab449551fde977a46a7606698f1bc3b8660cb95a7b86ea1f0a70"
    sha256 arm64_ventura:  "2918aab3ae916c515015e4c1018f4980b9f2a87915a7205532954fcfb2d40791"
    sha256 arm64_monterey: "21c7fa131f5b1c1c4419092d99bbdcd1b216c4bc12ba0315de63ea40bef316ab"
    sha256 sonoma:         "1e3ee39307d0a25068ee84ecfdee3a55feeb27cb27764e3a59263698d6952844"
    sha256 ventura:        "01baf473fb8d3f8df2ddfe27b3dc19b3ec5b208b1603b8dcdbb1978d7a68c830"
    sha256 monterey:       "06df5a44198ebccfef6fffb263c10c48a33584648a6a86e5af8f0e2c8f25cd37"
    sha256 x86_64_linux:   "d795521a9462c1fb5de0cbb911aeb5071d9318c995e956bd8e25997a191dc711"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
