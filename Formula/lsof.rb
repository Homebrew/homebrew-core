class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/4.94.0.tar.gz"
  sha256 "a9865eeb581c3abaac7426962ddb112ecfd86a5ae93086eb4581ce100f8fa8f4"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b446898f51c1ba795ee34955ba5f2a9f482c5cfa54973717db1ed40dfd44af7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3202f83509eefa73603b865ea4aca0433bbbf69d30f43d229a5ee256d1977424"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7a23611d5ed1fdb24ea4fd8dceec7a51f04d1c582dfe5dc4941323738aafd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dbab0c2a35d97381ed52fa32e1507c0fe83bc405fc40c4d00c79e12c79cffe4"
    sha256 cellar: :any_skip_relocation, catalina:       "58d2ee9a7484541a7280f5a139f2d0454b494f54bca3b9f10273e036d8071bde"
    sha256 cellar: :any_skip_relocation, mojave:         "9eb185a83e641bd8bd90fab3a8cde572b23ebb1ce269a8832fb85a66c5037318"
    sha256 cellar: :any_skip_relocation, high_sierra:    "268fe15ecc8d9e4dd4f2f45737c921e54a5aa999f15ab6b724b9bd34deeef8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee8fc9744aa9543709ec247328c89e361dadde77cc64d10a81aed761e5a0f47"
  end

  keg_only :provided_by_macos

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
