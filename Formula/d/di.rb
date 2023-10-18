class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.52.tar.gz"
  sha256 "b775ea8acb089c3440a8621da684fa8f98f6551c06e705593b79d4fe82b57a1f"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db8e0c6832115043941f3518779553dc405f8a3fa57149f046299865fdd12fa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e40f8f265d838cd1ec9a08cf7e32ff11557425549c8dff1b673753885bcdbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac45da534fcc3269043919dbab98503fcae309a163efab1648267f011af6b332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f73bb88a66c30a12e5f099cd22795b75b4920fb60be36aacda9e4a1b9ad537"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3cb664f7767099204baad7b5c3c6262b71251f4b52b2309136ed6154488e91d"
    sha256 cellar: :any_skip_relocation, ventura:        "4308fe40740ad7417c7a354862474df107479800fa869fb10f8d43e394652992"
    sha256 cellar: :any_skip_relocation, monterey:       "128bb07860843d8219d3a3ea7062904ab09e549d567217c6ed887840ed9d02b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa7f7ea4570b52e2dfd987a587856f931eb8c0db98b625fb10c4e7a8f5dccbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68964c84277dc1365199a0838e3d238c243c1e4acfff7966516d2bd388c15e19"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
