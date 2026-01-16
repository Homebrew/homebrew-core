class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://savannah.gnu.org/projects/libcdio/"
  url "https://github.com/libcdio/libcdio/releases/download/2.3.0/libcdio-2.3.0.tar.gz"
  sha256 "37bcb13296febbcff9dc4485834bac09212cb463c31fcea52f70ee1dd3a5a5de"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0540e17ae70efae2eed49362ed8facd0d34e107fe1d957ee0e65163d73a98157"
    sha256 cellar: :any,                 arm64_sequoia: "4d78ef901f92ff3f14d5809a48cc58dcc8a9b52b615645dda588c80814106ebc"
    sha256 cellar: :any,                 arm64_sonoma:  "a5f3c809caf711932d2f63d9dd90b4279749819c8a27fe529e4a1d7d163e7fad"
    sha256 cellar: :any,                 sonoma:        "f5f5849a0fba0231d2ec81f8a0e14501d25fbd5c1085ac150163c3b88f4eae42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "094b43451bd995b9369199268863682ec177fbd2a19da2e88ccbb37e26cafede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ce8a6bdca96d7b05c643598a02b3de6f13d70d845cbdd0cac40abf808255a1"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cd-info -v", 1)
  end
end
