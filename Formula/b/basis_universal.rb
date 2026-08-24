class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_50.tar.gz"
  sha256 "216e49e1f4213d4bfa4afaa07527e16bac28533dddd444197d3aa19230ac130c"
  license "Apache-2.0"
  head "https://github.com/BinomialLLC/basis_universal.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca0e7381aecf90e837c290607cbde040524b9d7be5588b2495dd5bb1115a1b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cd539cf6c63cff492c5a697ac2110d232842338bcda7fe94c8b1e561ceb2820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c878ae8466c61825b4ce69d2919afd22c99ffc216f061cbbfb1f4681e19d022b"
    sha256 cellar: :any_skip_relocation, sonoma:        "120a5489794e9efc6cb76d825cb62efedd342fb19a0b9154fc3a3fb38901663f"
    sha256 cellar: :any,                 arm64_linux:   "78d3a5e266102c3d8a44c24fffbda6da2ee8681a8c7ced000a100893b0859251"
    sha256 cellar: :any,                 x86_64_linux:  "73594c3161ef65b170a21add6063a3a0cdb721c0f9b2abd236e3c7e5ea8b8dff"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "bin/basisu"
  end

  test do
    system bin/"basisu", test_fixtures("test.png")
    assert_path_exists testpath/"test.ktx2"
  end
end
