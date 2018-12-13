class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.8/libatomic_ops-7.6.8.tar.gz"
  sha256 "1d6a279edf81767e74d2ad2c9fce09459bc65f12c6525a40b0cb3e53c089f665"

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
