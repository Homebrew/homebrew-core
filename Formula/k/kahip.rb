class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.22.tar.gz"
  sha256 "3cbadfbf8d503351d921531413d3b66ad347a6d6e213120db87462093bb66b7c"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8302704ed34978e1bd2633a245c6d7e500f9ce23e5b241d30ab9859de2702c4"
    sha256 cellar: :any,                 arm64_sequoia: "4e0aa3de659d6d45326516999583c2d61176cfc5f45d6cc23989521079dc08b3"
    sha256 cellar: :any,                 arm64_sonoma:  "87f67dfdbc70100b07ffa47e7814918b4310dc49ae9a700e90c6ee2eb1b76edb"
    sha256 cellar: :any,                 sonoma:        "6db59fcd4c5784a947ff2d72ad7bad65cfeca35f6d22751e23400b3187c0ff6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dcc6cbd9ab85a0bfaf7267af73d673f4e48f6da591310384e8fac252dc5b6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49e5ecc90d304d3ec5dd892cb988b2a645fe486c75c86551f23d71485044604"
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
