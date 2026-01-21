class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_0_1.tar.gz"
  sha256 "ba83a292dc92f0ea5344208fb0befb41a4646075097e20055b002541de142091"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ceac130f66b043bd80f6438f049e3d5db720d6631c80667b66cd2d04c0cee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4deabeea0e1bb3f99c4e1ad044eb42155a41cf7fa0e36a6fb7514b0f01fc1e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc92c1cca424f0e93115021cf4c1becc022101f9c50b4094f1a783439d7a9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d6fdff6ca2e1a529a7556186e27bcea4d5c6a2c55a598e6a709c54698481ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cfbad1d8dc00ca6460c992b0840c77c5f98a44a9fbf362f172b42dc40000532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b7544b7f83eb4a9e9eb3bff33b5229efb9fd0c9dc09a877390496b2c71b42f"
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
