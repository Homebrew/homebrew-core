class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.19.tar.gz"
  sha256 "ab128104d198061b4dcad76f760aca240b96de781c1b586235ee4f12fd6829c6"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "120f2ef20755a12ae79f34563dd9268b1242646c77bab917767c5f8221673fa7"
    sha256 cellar: :any,                 arm64_sequoia: "a603683f8c78a70bdb2211982cc1cf3d288b994703e6ef640cbd556d12e9f670"
    sha256 cellar: :any,                 arm64_sonoma:  "7ccc9c3257e7796e87e8c6b7c7d7ed82a62a2838e328af5bd02ffdf2966dee45"
    sha256 cellar: :any,                 arm64_ventura: "2d98c8b7c22d731f02b49513390e3fd660861b2f38549bf010790b05173c9ad7"
    sha256 cellar: :any,                 sonoma:        "4ebe2ffacfa884b848c7e79e8859cb680b5d155cf791735471b346a9052831d5"
    sha256 cellar: :any,                 ventura:       "55409fad4a79e0e3883a2b3ead8e50ec49d233d5a02791d1a53fce2c061943f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd117a91536bee09dd4e05a86ca6908a0eb3fa274c409ae192c544bfe177e02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35d6e4fa54607415e231985844a7d51404e72bc84fb3b48a51164e3faf16a18"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
