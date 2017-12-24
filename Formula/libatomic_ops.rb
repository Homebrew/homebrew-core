class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.2/libatomic_ops-7.6.2.tar.gz"
  sha256 "219724edad3d580d4d37b22e1d7cb52f0006d282d26a9b8681b560a625142ee6"

  bottle do
    cellar :any_skip_relocation
    sha256 "dac326b799a710b727d87dd76811395b5c272efdbd0a5fb45d1e0603e0a0d921" => :high_sierra
    sha256 "9e2926d6e7e2ce0b177411e55e76256974d6175874936009244bdc5f8c06971f" => :sierra
    sha256 "4094450946626f7cd537cb4d821d7da0f8ae85d4dce46f1631799225506b9189" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
