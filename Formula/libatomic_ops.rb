class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz"
  sha256 "587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af"

  bottle do
    cellar :any_skip_relocation
    sha256 "d102cc71b5959eac9f8ecbc5029801ea2a544ad5b6602c586e5d5d33c67ebd55" => :catalina
    sha256 "b509d8669c5336775b0462c3e1464419d083bccc0bf43f8dab8fa3eb0ac44405" => :mojave
    sha256 "2e3053c22101fd8baf693ca404f258763b15e77372b5293e999f8bbc8b032522" => :high_sierra
    sha256 "d94aa0351ce2de312d0b31a64d48059473a170d9704968378cf121ad097d7d9b" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
