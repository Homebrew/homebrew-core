class Dcfldd < Formula
  desc "Enhanced version of dd for forensics and security"
  homepage "https://github.com/resurrecting-open-source-projects/dcfldd"
  url "https://github.com/resurrecting-open-source-projects/dcfldd/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "52468122e915273eaffde94cb0b962adaefe260b8af74e98e1282e2177f01194"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e637feaefa3854ecdd910334ae5da97d68614e8e29a369fa93f6aaab9329a173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fb762dc8ff64b3829c069c5d65b33af13b1f0610bcdcaa8d6fa2de18d6e28dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "209e4325ac641238a6be2c411e9d964a0f4efbb87cf5b69ffcfdd0efbf7ef523"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ab38a209df9b31c0f6a4a9212fa29f42569a47337046bef83c2e91121b3e23"
    sha256 cellar: :any_skip_relocation, ventura:       "3a087faea51f503a26ec7376b5955be58489380439b83ef554ab8c3be8669529"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c400bc4961787061faada1c125e0dc6c5e2fe8f0ba1604f4e87d591489ce5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74daa691d054382c0173e9d0942a6ab7a91ce53a1f222c6297c2b9849a1d38b8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dcfldd", "--version"
  end
end
