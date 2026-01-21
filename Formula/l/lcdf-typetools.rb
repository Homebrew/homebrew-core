class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.110.tar.gz"
  sha256 "517f9ee879208679d3224a14d5e6eb20598fc648d5c3562708083d003088a934"
  license "GPL-2.0-or-later"
  head "https://github.com/kohler/lcdf-typetools.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lcdf-typetools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "014a5797b27475c13f3b8511f5e5c76db375fdd5b1a7aabbca35a2d020918aec"
    sha256 arm64_sequoia:  "5e354428d6719b3944d45a3836a61964221ae31b65a35cdc04d92a89c72bcd10"
    sha256 arm64_sonoma:   "adebc013b9cd122099069d78f3da8eca8c86f585e2e08476f4fafe852acc6414"
    sha256 arm64_ventura:  "8236a9837f726de7f4134db255df5df0c74b6d3aa0827a583e5c3d121e2170c1"
    sha256 arm64_monterey: "be7523e73f08148f0848d41a93ae2443227d06d88da621f576c7fe346070224d"
    sha256 arm64_big_sur:  "bfdcd6b8f33e4a552a0ddc6eb20ee8311332477647ac02c96ce92eb0f3a0f10f"
    sha256 sonoma:         "ad5b178aa2847ac19ed1dd15d43137d90758d84978ff8b36df9db66437323be8"
    sha256 ventura:        "1dd345c1b3f20d16d2303573c9324047172f728999ecb497cb6e13c56e31c96a"
    sha256 monterey:       "81daa75ad3bfaf2257c2967749981284d2a9076bbdd60176f6ee845b6419a90e"
    sha256 big_sur:        "34f194d4996198a1c3f5ffb49b65c2e00af73e88db861d49a22f7ee9dcf3ea3c"
    sha256 arm64_linux:    "934b2e2900efd242c6ca0f1d6a4b4c25e92e5ba0f6548fb6899fd8ae83a529f6"
    sha256 x86_64_linux:   "bc299e560c0228488ee8205b9e9a91d007d205beddd06c0461fa6e8d4e9d2589"
  end

  conflicts_with "texlive", because: "both install a `cfftot1` executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end

  test do
    if OS.mac?
      font_name = "Arial Unicode"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    assert_includes shell_output("#{bin}/otfinfo -p '#{font_dir}/#{font_name}.ttf'"), font_name.delete(" ")
  end
end
