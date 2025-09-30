class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/refs/tags/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  license "MIT"
  head "https://github.com/six-ddc/httpflow.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5cbd7cedb1ff1b35afc85432620f05dd67f683d8192c67df5af172a583c762df"
    sha256 cellar: :any,                 arm64_sequoia:  "ac62f29bcb5a484af3755990f8ddd109dce6df7a261e281f9846a383457f815a"
    sha256 cellar: :any,                 arm64_sonoma:   "2c7c2232e112599cf10e22ac013df5cf5823f6071292fa91a5252480539c85b7"
    sha256 cellar: :any,                 arm64_ventura:  "4b3f8c7e2ac615472630e7913d4e0461199a5f9fc6204db04802c6829d359b1d"
    sha256 cellar: :any,                 arm64_monterey: "90a537d7db4c639129394ae490211a16378c9549a777e80b3e050197fac49d84"
    sha256 cellar: :any,                 arm64_big_sur:  "4ad73cc6cd313d17634e78df0795ce7ad85b929e05efaf219768e9929950a663"
    sha256 cellar: :any,                 sonoma:         "f33fafda905397e163ece952c25c475d5eb49ababa691b63ed26436f9873291f"
    sha256 cellar: :any,                 ventura:        "a32947a5a6a4de44b49ace73f7bfb89047eaae6bc7c8e9c101e306aeb075c7c2"
    sha256 cellar: :any,                 monterey:       "2733c1f43d12b4581542233c0b0314189756d98b0fbd76e0899ca2342f811bc3"
    sha256 cellar: :any,                 big_sur:        "8fd53a648dc88731b9dc6dd03fbfa68302f287e8c3eb2685273f10d691aee13e"
    sha256 cellar: :any,                 catalina:       "2b7b63f5d82139b4fc017b8848e3b29608738cd510ef1350710c6224a24079a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a0c2f859553f2a542f2ab254d0bcfeedbd29c3f5f8b626cd699c81a2912b77e0"
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
    system bin/"httpflow", "-h"
  end
end
