class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.37.tar.gz"
  sha256 "b59099d42d5c62a8171974e54466a688c8da6720bf74a7f16bf24fb0e51ff92d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4606a60336899fd6999316c0d7de2a23b87467f6d77b0eef9000260e899a31fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14600f40dc8304b14b5e9620ea0d58c4d518cebf581b1a44e0adf78206c6f3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e975b49bbc2f53fc937ef2efd886dffc00b14221056c378bfa12a98ce1bb9aff"
    sha256 cellar: :any_skip_relocation, sonoma:         "18c52b3d11e199a2f960a0781007204b7d0d9de26f26f13670262c6e4a4db5b0"
    sha256 cellar: :any_skip_relocation, ventura:        "15e4e2f977211365ccae723d41eb8e1d73722a2d28ab9f0fc4887a3814a8dfe9"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d576aba0d1979b57fc1083143b703c0876c932688156ed7de3c7ecd5aa7082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5fb7416705b1cfed6f18938ba6e54c5da7f9aa81a1ef77380afb67171cf47c"
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
