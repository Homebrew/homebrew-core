class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.25.tar.gz"
  sha256 "3abad20158887b585b4d4792c35fa9023b7fd634b2bc4494334a3951b69f4842"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e36c7f3ab5780386c19bf7dc68af8ded3b3e3dab99ed92249ea0c0016027a2b"
    sha256 cellar: :any,                 arm64_sequoia: "efdc1cd8ad2cc578bfd7565fbf5d6a8b3e2b2846ab7226098f2f46cbd336a2c4"
    sha256 cellar: :any,                 arm64_sonoma:  "6202547db3fcc0681199d34244fe2e2c3b5ee6c53ef7cef688e6381aa4a3964c"
    sha256 cellar: :any,                 sonoma:        "946fcbeb2f1f282d71daf56bf5060b5c3ddb09d0459183e0f3d294a3d89308ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ab7889c908ca241a175d788b1c19569158b939d18346220695c490699e348c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d11325459b8017581d809476311f68dfdc1cef415de405f4f59de49f082d3010"
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
