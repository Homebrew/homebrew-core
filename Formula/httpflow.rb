class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  license "MIT"
  head "https://github.com/six-ddc/httpflow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b3f8c7e2ac615472630e7913d4e0461199a5f9fc6204db04802c6829d359b1d"
    sha256 cellar: :any,                 arm64_monterey: "90a537d7db4c639129394ae490211a16378c9549a777e80b3e050197fac49d84"
    sha256 cellar: :any,                 arm64_big_sur:  "4ad73cc6cd313d17634e78df0795ce7ad85b929e05efaf219768e9929950a663"
    sha256 cellar: :any,                 ventura:        "a32947a5a6a4de44b49ace73f7bfb89047eaae6bc7c8e9c101e306aeb075c7c2"
    sha256 cellar: :any,                 monterey:       "2733c1f43d12b4581542233c0b0314189756d98b0fbd76e0899ca2342f811bc3"
    sha256 cellar: :any,                 big_sur:        "8fd53a648dc88731b9dc6dd03fbfa68302f287e8c3eb2685273f10d691aee13e"
    sha256 cellar: :any,                 catalina:       "2b7b63f5d82139b4fc017b8848e3b29608738cd510ef1350710c6224a24079a3"
    sha256 cellar: :any,                 mojave:         "6d911ff1c720035b0b23cf994fbbb37e7d1372dcd32eb60bc54924b78b444431"
    sha256 cellar: :any,                 high_sierra:    "cf54de7d5e6fda49966d75a0c33580bb8e64d3d0fb6c39337a03e21fb20682d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4974439a78ea50c5a49a972f340395f0f2a8305ff2980e9eab9bb27b94de9778"
  end

  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
