class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.35.tar.gz"
  sha256 "36b98f35622ee594364bfd9a527523a44cda0dda2455ba9f2dcae2cd7dd3859f"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ea877454a808f6e3dee44da6e88a23cb7fb98c218cc54d11c7f7d01e6902644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e08ef3728525608cd561d1dc9172caa0306f4511150268ada52c4e9952a8181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc40c0fe242c0a51e578097e53281dbd74f6edf5f5cbfc0d0860a4401a40f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66df4935ab6ee0eb8c5568e6e7a033fb1f45f73f48088afecc07d1238bdab896"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c686b85f37def5a14961f83649953e05ba4e9ddc2944b2ca49501afa70cc00e"
    sha256 cellar: :any_skip_relocation, ventura:        "276a9f2c59a04ffbabbfe58ce93dd14a523c297538528059953fddf425326973"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ed09c6cb777970c954ab462f61200ab0e500321228c59e0cb54d2ec0594dab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0ef721fae243da1ed185c357cf63d585300641116b3d7d31bf9f4374f2e3396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c8a31803dda9376ee468b6c7c5e46c466b0d032b1163c0644a529351d918b8"
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
    system "#{bin}/fio", "--parse-only"
  end
end
