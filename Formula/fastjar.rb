class Fastjar < Formula
  desc "Implementation of Sun's jar tool"
  homepage "https://savannah.nongnu.org/projects/fastjar"
  url "https://download.savannah.nongnu.org/releases/fastjar/fastjar-0.98.tar.gz"
  sha256 "f156abc5de8658f22ee8f08d7a72c88f9409ebd8c7933e9466b0842afeb2f145"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/fastjar/"
    regex(/href=.*?fastjar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5fa05b957bd369862d66cefb2cfe2ec5fdb86bf6ea3bcde2b8f95c1d872a293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9bb50e8b725164441e747625b381631edf82e0040babda6f187466295f80e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "06ceeffa38b10f099a521d5ea3ac4dd52d6d0d5740c3fc64f6b4e8509a842cef"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cbf953373b3d48accd872aa603fa66fb3b96e1ec33d4a17dfe6da2f97ad5cbb"
    sha256 cellar: :any_skip_relocation, catalina:       "ee758c76cb694c96ea30cb9e6ac204f2797c78be36610dcdf36c2a75301b5835"
    sha256 cellar: :any_skip_relocation, mojave:         "2dba61ec801db3d83692b9c9dd26eab247cb4bb6a6d6afc27f059bb6ba6052e5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "87b2c870895191b309b595481f73346e763b87c661e64ef35b821e54395d5cc1"
    sha256 cellar: :any_skip_relocation, sierra:         "35230e788987e3a3c63d126af24c634bcbf58c0a320223d61f0eae69f6cbcc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac2c41e11f88db5dd88b6cfceb7620f9f2dc26a6f7a89f224f8bd874774c6d3"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastjar", "-V"
    system "#{bin}/grepjar", "-V"
  end
end
