class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.10/abyss-2.3.10.tar.gz"
  sha256 "bbe42e00d1ebb53ec6afaad07779baaaee994aa5c65b9a38cf4ad2011bb93c65"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "274f0f758f4cc8852779e2a55f8900ea34ccf7dd0e784396752f03c7e6c56767"
    sha256 cellar: :any,                 arm64_sequoia: "156d580ae0392d7045dd60c744d4a1a32206a950c86588cb25aa600dedd0e8ae"
    sha256 cellar: :any,                 arm64_sonoma:  "61982df06da982cf2f7edca391a61f935cb3c1542d165f1ed69f60a33b4a6031"
    sha256 cellar: :any,                 sonoma:        "cd3d743d197a92d98b4cd43a45615de53d5cc403a36ac9e41cdf6e47ce7aee44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e42e8b368589c943fa3bd23e3c8f8a5af03b307530c445309dc45a72e2d2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b36e68d3d7b88d89656707fd50185e8649d31bac5359575f160dc875c1d28f"
  end

  head do
    url "https://github.com/bcgsc/abyss.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "btllib"
  depends_on "open-mpi"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help link to libomp on macOS
    ENV["ac_cv_prog_cxx_openmp"] = "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    args = %W[
      --disable-silent-rules
      --enable-maxk=128
      --with-boost=#{Formula["boost"].include}
      --with-btllib=#{Formula["btllib"].prefix}
      --with-mpi=#{Formula["open-mpi"].prefix}
      --with-sparsehash=#{Formula["google-sparsehash"].prefix}
    ]
    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
      sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
    end

    testpath.install resource("homebrew-testdata")
    if which("column")
      system bin/"abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system bin/"abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system bin/"abyss-fac", "ts-unitigs.fa"
  end
end
