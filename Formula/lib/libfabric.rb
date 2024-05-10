class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.21.0/libfabric-1.21.0.tar.bz2"
  sha256 "0c1b7b830d9147f661e5d7f359250b85b5a9885c330464cd3b5e5d35b86551c7"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ec889d7aa27d4a50f7f596e1e1528a521f6cd764f1bd3a8d69509c5e1b238c9"
    sha256 cellar: :any,                 arm64_ventura:  "17434db31c14c85b4176c5ace45df1e8ebcdbf4c72cad958b6c3ec40e4a10c59"
    sha256 cellar: :any,                 arm64_monterey: "39e5409ecf63203a9501c8834d50c129639694ed9b7f6baa93ef4907a109fe73"
    sha256 cellar: :any,                 sonoma:         "9b24948488f488204ae3eda01d87bd1b3f753e8c3c66fc545edb1ec335978c41"
    sha256 cellar: :any,                 ventura:        "37279c5217930d20ab6cb6530a7a1ba78cdec38d4a5a0cf027199cf2f92d4b50"
    sha256 cellar: :any,                 monterey:       "889648653f026151d7950b8a1cc58829ebc8559af4256ac6bee000b038410bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249165db98ba64758b42ded9d785165046039ebe6ef6aa74b9f2ce10c90b2278"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
