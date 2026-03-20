class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_1_0.tar.gz"
  sha256 "ee1dbeb4c16699b577a0c78dce337bbede268e04bd2d463946971f8cb1e9c8df"
  license "Apache-2.0"
  head "https://github.com/BinomialLLC/basis_universal.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8878b4f2ecde5c3ecf036eae7cf1ca38f88e3b0fb334fc4b71cfce53de3a70e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "996300ae778bc067a3f9ac741afb9867b27d6518e6dd234db25d0c53e6be7ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df7340c87bdea8f7653bfa2295c4d7d27ba0fe9924f599dca110d7d6bcb82b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca32b4ccf9598b1c9c49196d55db88a43f2cb70e3b5a2eddbb96d7800e196442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "192aed9390f05e40a1f084e3dc198d685628f4a56862c457686bd87b9e56b1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "979f624d35c29a11da6c8959f27c484c7e7c2a12860699854b1cf129debe1166"
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
