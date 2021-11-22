class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.2.2.tar.xz"
  sha256 "5f1f959877852abb3153fa407e8532161a7abe916aa635796ef93f8e4119f955"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bffaadc88542e5b873898750254f62cb71acda76a6055f41e7305666da8e7e1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f131e857951e55ae5f61836ce5f86944ba25812f85dff9e9cd868af7eb6adf17"
    sha256 cellar: :any_skip_relocation, monterey:       "5493f944a055f0a9531df296e2901e0a76dcd075dedf165345ce731772b56ca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee879a482a1437018b7db5a44863b230e211fb7093acaaae35730097c08896e8"
    sha256 cellar: :any_skip_relocation, catalina:       "ed41231b1e7d1760603e39f3e161be7cf817abc978f70c0dcbaec3bb206d9d8d"
    sha256 cellar: :any_skip_relocation, mojave:         "4da5825b9f51a83c7de24d289719f0d341b79685a7e1580f2de867e53941934a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "437b8823d451f79f1ad8e2420387a3f50c3dc5919ef19717d41c437a88b77247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6fd7435b038f21853ca4066182eb24d6088484d9a5299fd1528e275bb55144"
  end

  depends_on macos: :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
