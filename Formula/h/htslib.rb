class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.18/htslib-1.18.tar.bz2"
  sha256 "f1ab53a593a2320a1bfadf4ef915dae784006c5b5c922c8a8174d7530a9af18f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7852871f96f54364c39fdcb5458114412e3c864b2b8cf4829b2b0d4adfdf59a2"
    sha256 cellar: :any,                 arm64_ventura:  "91a1f7a53a4abbeb29c62182ee75ce6bb5fcbdc57f04a36831e482c82ffa8826"
    sha256 cellar: :any,                 arm64_monterey: "b3b38e38ae0e95509243d7f12b68cfba0ebbfc27ecacabe8d0f80f941ecedcb6"
    sha256 cellar: :any,                 arm64_big_sur:  "2c23c15552d3b1b6d283b9ed2c3985759cde5cd051fa06251859b0c46a305f78"
    sha256 cellar: :any,                 sonoma:         "8c2638523c045f793a8d7e52b1923df287734538f754f65184697271c46221b6"
    sha256 cellar: :any,                 ventura:        "c1ded4ddaa43bf6bf33346a02291e37a4658915733d7efcdc06cf7beb46794e3"
    sha256 cellar: :any,                 monterey:       "c7b62fc25f7ba87ba05b03ed4e2956ec452d7d581de22fb7725bbee454aa750f"
    sha256 cellar: :any,                 big_sur:        "b23cec30df6a656cd3f12afc92eb7aa11cce3d3c20f735482bced92a5e6a1eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a500e3984c38cf9e2b48d5b4c7c8ef85e234ab2d384bdabd449acac501d4f1f7"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl"
    system "make", "install"
  end

  test do
    sam = testpath/"test.sam"
    sam.write <<~EOS
      @SQ	SN:chr1	LN:500
      r1	0	chr1	100	0	4M	*	0	0	ATGC	ABCD
      r2	0	chr1	200	0	4M	*	0	0	AATT	EFGH
    EOS
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
