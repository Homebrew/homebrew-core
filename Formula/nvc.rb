class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.3.0/nvc-1.3.0.tar.gz"
  sha256 "6c98468ba73558c454176f5176a4c63c85bdc3c930be6f77fa3b7efb3aa8ddb8"

  bottle do
    sha256 "f11933a05847b9433fd505c03755767043872e145f247b7d87603e3a9dc51dc4" => :high_sierra
    sha256 "23b8d156e8ee517b80e7736eeb31bfa3ac59e30bbdca157b53320b8cf987b633" => :sierra
    sha256 "fec8eab13df57ffec18283f6a83366afcf431640f9e25142a4da04f63e43e2bf" => :el_capitan
    sha256 "f33ffc17ef6123f97750b76fddedbb6ba3865fab02ebbca04c7441631740092d" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    # Fix "error: use of undeclared identifier 'CLOCK_MONOTONIC'"
    # Reported 1 Jan 2018 https://github.com/nickg/nvc/issues/365
    if MacOS.version <= :el_capitan
      inreplace "src/rt/rtkern.c",
                /(static uint64_t rt_timestamp_us\(void\)\n{\n)#ifndef _WIN32/,
                "\\1#ifdef _WIN32"
    end

    system "./autogen.sh" if build.head?

    # avoid hard-coding the superenv shim path
    cc_bare = Utils.popen_read("sh -ilc 'which #{ENV["CC"]}'").chomp
    inreplace "configure", 'cc_bare="$(which ${CC%% *})"', "cc_bare=\"#{cc_bare}\""

    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
