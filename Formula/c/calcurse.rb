class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.9.1.tar.gz"
  sha256 "111f58413e62d47e6eda5807f63b589a2b458e4bf3c80f156ded0107957aa675"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "2ace74e21b55039baf868393b60af36180c2b735c7d0c2d13d200a9bde9fead2"
    sha256 arm64_golden_gate: "5d919d1105101456dc8edbd70ad16f914a028aa3210cb6d3205afbd8a9f2a4e9"
    sha256 arm64_tahoe:       "2ff5c6cda82119ae5677bd6f0331b6443f52a2a8472497198f5524b90c076a93"
    sha256 arm64_sequoia:     "f0c8b5a5111c647332d1ffc1e54b6eaa6d5884fc50ca4371b84d6005ab8468b2"
    sha256 arm64_linux:       "ef35631e6bd89ad74c524a86d281251aba13d1ddcd28ae65bc1e411dfc1487c1"
    sha256 x86_64_linux:      "b2343243b2a588c1d0538a1280d48b190f13a140826460ef5845d56c78e26845"
  end

  head do
    url "https://git.calcurse.org/calcurse.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
