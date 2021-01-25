class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.75.tar.gz"
  sha256 "2f9ddc4727af8e058e07bcedfa108e4555a9519405a47a1fce01e6420dc90c88"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.five-ten-sg.com/libpst/packages/"
    regex(/href=.*?libpst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "6f48557a8529e0bc989baaa72788c52289896194e069217bf8fe5cc771207a22" => :big_sur
    sha256 "669e325cb32cbad435d86606d40012aee6d9101b2ffbc6efc9fa101e9bcdf97f" => :arm64_big_sur
    sha256 "cbf301e72e23ecad7be367063b933bb9ce0ea430f5af413ad44f71b04e4ccae3" => :catalina
    sha256 "b5dff8dd482a5688ce97bc7407ad7a18d620dc264ba1962e155e862ae2973d2b" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-python
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
