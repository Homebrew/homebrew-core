class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz"
  sha256 "587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e045de065fa044dc9646937ac891452892f777a386029d5b91cbf4cad2b432" => :mojave
    sha256 "05f6848304f76ea640df1fd395a8e384dc5de0d13ee7962ca11b90f97748867c" => :high_sierra
    sha256 "1bc588fffdda2bdd320e329724006dffc941ccc104886f14f7d963b18ed1a3e9" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
