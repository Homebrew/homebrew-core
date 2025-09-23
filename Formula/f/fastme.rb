class Fastme < Formula
  desc "Accurate and fast distance-based phylogeny inference program"
  homepage "http://www.atgc-montpellier.fr/fastme/"
  url "https://gite.lirmm.fr/atgc/FastME/raw/v2.1.6.3/tarball/fastme-2.1.6.3.tar.gz"
  sha256 "09a23ea94e23c0821ab75f426b410ec701dac47da841943587443a25b2b85030"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gite.lirmm.fr/atgc/FastME.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "4e5a8fb8bcbb621a2b49132177b1d4672669a8994b6bc31e5fc654082689c50c"
    sha256 cellar: :any,                 arm64_sequoia:  "7429f457373fef2d2419f738d603b26316c7c605628332078ab9e0160887c27e"
    sha256 cellar: :any,                 arm64_sonoma:   "6a48e0909778d1439c1e582406533caf6be960f927ab8dc1fd932ca8f266c5b6"
    sha256 cellar: :any,                 arm64_ventura:  "cdc10bc105778a517f7072abccc2b5f7e743230f944c2ef7ec80cf949dbdf208"
    sha256 cellar: :any,                 arm64_monterey: "897103ed06501dc198084a1a2f9ddab6a6cf65f2662f2c76060cc328c6738a75"
    sha256 cellar: :any,                 sonoma:         "c39feda27c7e0280a7ad83c8426d6417ef33d9c3cc2a322a5a2c234f754ae5b8"
    sha256 cellar: :any,                 ventura:        "819551b354f63fbf7ed7c93e427352457f966a67abdf67d78bba11ac6a6e8991"
    sha256 cellar: :any,                 monterey:       "561643936ba17bc31cf1a62f250edc50b4d438c1628a90c3938fe36ed428dd6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "15f3314eba3e5a65418012389a8ccafdff816eebb6434fdd51cb5669955d4b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca5ecc7fec2a963b3ee5239a65e4efc836500378eaad4d65fe48f07168095e1"
  end

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
      ENV["OPENMP_CFLAGS"] = "-Xpreprocessor -fopenmp"
      ENV["OPENMP_LDFLAG"] = "-lomp"
    end
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.dist").write <<~EOS
      4
      A 0.0 1.0 2.0 4.0
      B 1.0 0.0 3.0 5.0
      C 2.0 3.0 0.0 6.0
      D 4.0 5.0 6.0 0.0
    EOS

    system bin/"fastme", "-i", "test.dist"
    assert_path_exists testpath/"test.dist_fastme_tree.nwk"
  end
end
