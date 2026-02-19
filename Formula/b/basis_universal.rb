class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_0_2.tar.gz"
  sha256 "416efbe765c59ce6930eed51cfa0f1c67abefc1f12264cc65a27480f4a73186b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32b84606de858f5bbc07512b9ffd999038a6ecef0f8e2bbe17c77cd170074a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c018a0c9cc4914bc0a235c0229db4f47853f3bdcb5dd509baf483ff22e28d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be868441d8ae0d98017072da3fe3f1ef6d777f1fbe9345a2dfb809c2ab70238"
    sha256 cellar: :any_skip_relocation, sonoma:        "29eb21dcfeeea1713de8a493853dc3563902d2c1297257de15df7e90678c4b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8d1b65bc192b4bbb02fc9ef7abb5e97b29fb4bda2b797d680eda2bdbde1208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d394fc751ec139e6dcd5213a7d520933b53be30fb42df4e7ee7487a2aa68e199"
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
