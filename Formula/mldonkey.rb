class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    sha256 "da8c1bd6176070cca2b681d5fb56888ea0704615ca75ae7c74a555f597689116" => :sierra
    sha256 "3ffeb23b857161ecf7d48d6479f0494012f63245069591b7f3fbd728fc1a0f8c" => :el_capitan
    sha256 "69891decdf1c9ae9b9b5b2880c6b4cbbb7ecd65792929c0672d27caeb872520a" => :yosemite
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libpng"

  def install
    ENV.deparallelize

    # Fix compiler selection
    ENV["OCAMLC"] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mlbt", "--help"
  end
end
