class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.38.tar.gz"
  sha256 "73b3ca18a66fb88a90dae73b9994fdd18d35161d914ffe2089380760af5533cf"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "654a917a60065aa8aebb4f1432956030130e0d94e36919bdd954062bf070f809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "067e8d1d644620efa3a45d83077f9fcea61c0a7b1259841f3121fd1da032b874"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "201e1936bf800e1be7315bc53a1706ea3d45d22064c0b76755cdcb371a467c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc727fa315f45e7c596ba3f9ddd0e4247ecd17b6e96802db60feb28dc360a67"
    sha256 cellar: :any_skip_relocation, ventura:       "2c49f227e53f2906dec0471c99ea4c3dc8d8b763c140fc5f4a021b493f68c4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5894295d238757320da3650b40ca675cd4793ae050017f7ab211c319077bce4"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system bin/"fio", "--parse-only"
  end
end
