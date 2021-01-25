class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://github.com/lsof-org/lsof/archive/4.94.0.tar.gz"
  sha256 "a9865eeb581c3abaac7426962ddb112ecfd86a5ae93086eb4581ce100f8fa8f4"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dbab0c2a35d97381ed52fa32e1507c0fe83bc405fc40c4d00c79e12c79cffe4" => :big_sur
    sha256 "3202f83509eefa73603b865ea4aca0433bbbf69d30f43d229a5ee256d1977424" => :arm64_big_sur
    sha256 "58d2ee9a7484541a7280f5a139f2d0454b494f54bca3b9f10273e036d8071bde" => :catalina
    sha256 "9eb185a83e641bd8bd90fab3a8cde572b23ebb1ce269a8832fb85a66c5037318" => :mojave
    sha256 "268fe15ecc8d9e4dd4f2f45737c921e54a5aa999f15ab6b724b9bd34deeef8d1" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"
    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    # Source hardcodes full header paths at /usr/include
    inreplace %w[
      dialects/darwin/kmem/dlsof.h
      dialects/darwin/kmem/machine.h
      dialects/darwin/libproc/machine.h
    ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

    mv "00README", "README"
    system "./Configure", "-n", "darwin"

    system "make"
    bin.install "lsof"
    man8.install "lsof.8"
    prefix.install_metafiles
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
