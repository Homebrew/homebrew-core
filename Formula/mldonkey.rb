class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    sha256 "7c66f7ba84b1504ff494e19ad652041d586a95e48bdd3c890b4b7a957689ffbc" => :sierra
    sha256 "c1052febc26c0c657bc0a0fce741500caacbac4d0ac6aef543a7e428009a550f" => :el_capitan
    sha256 "36f1e19c5a335cd4a2c5a68dca7dc3c43cd77655a1eb905b6cede5f74f73fcae" => :yosemite
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
