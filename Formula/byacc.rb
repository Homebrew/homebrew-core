class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210109.tgz"
  sha256 "9e7d7768587141e7784492615dfefc70a8e00410043b63901efedc1b50c19b97"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72d12d69a0acb74ca78d7b6e78200601b696d9c9267fc7f1d57d08f4654c172f" => :big_sur
    sha256 "7a08cd6c6f6a4fb998ef65c16e481dd4212ecfb359fed6b86acbf1272b5dc40b" => :arm64_big_sur
    sha256 "57aeaa751341ad11d735626ad343aaae7dbb9401697c917a4c7268241751e435" => :catalina
    sha256 "552cd6f3ad41dc11ddb8535b495594e7c63e9208e594f9bef29d317669512d6a" => :mojave
    sha256 "f8ea7c1fea86a6814bf332b8a35e81a19a28f380c4beb28d7bf0eabebe96cf78" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
