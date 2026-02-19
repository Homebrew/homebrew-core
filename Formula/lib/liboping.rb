class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.10.0.tar.bz2"
  sha256 "eb38aa93f93e8ab282d97e2582fbaea88b3f889a08cbc9dbf20059c3779d5cd8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?liboping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b799d5c3ab5ca9ace10e0b8e9f338111ce0220b1df97d3d5c025a18e0c6d47a6"
    sha256 cellar: :any,                 arm64_sequoia:  "5395bb6ef912f023eb75a29a46eb614a0fb9dec8f65fe29f40af6173d0f8f809"
    sha256 cellar: :any,                 arm64_sonoma:   "e2142ec221a13c7102978228b5d3ffd61a182952bb470ef0cd63fd1201ce6411"
    sha256 cellar: :any,                 arm64_ventura:  "4f96385d085c835f78741e71350fba8666a9692673abab3681722f7dc22fef1f"
    sha256 cellar: :any,                 arm64_monterey: "88e26997cd417b2be6c8323451267524135044c033e6c34772cf9dc7812d9d4f"
    sha256                               arm64_big_sur:  "a8ea63333bfc0a7ec880d0c5727316ff622ff2f4854efc93bd9bc082080f9365"
    sha256 cellar: :any,                 sonoma:         "c57fcbbbefe1baf0972917c9d6a65843e3b5b1b24d777cc3936f423dd086fdad"
    sha256 cellar: :any,                 ventura:        "8866dff120426703941ef3eff9e6253c9ed14fde9181dc4a65207599926d973a"
    sha256 cellar: :any,                 monterey:       "0e71715fba4fca28f5488409e5529ac61b7f166cea4cc2180967cc4d9a50dda6"
    sha256                               big_sur:        "0edb72c3d81dbc8869b28d27f063372f7eed0ac4318624fe94e4ac5be7d2337a"
    sha256                               catalina:       "997e8eb17c7878cbd0c34bd6532b76ef804899751a58b3b434656d1b9ced07d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71cfbc992467da7e4933d64ac61454004ddac15ab93c28b33e502299e2789a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3979a8a214b2384b5c18cb7ad0d1ed49d27896b7972a2ce93dce2e0d76ad82"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"

    # move `Net::Oping.3` manpage to man3 dir

    if OS.linux?
      mv prefix/"man/man3/Net::Oping.3", man3
      rm_r prefix/"man"
    else
      mv prefix/"local/share/man/man3/Net::Oping.3pm", man3
      rm_r prefix/"local"
    end
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end

  test do
    system bin/"oping", "-h"
    system bin/"noping", "-h"
  end
end
