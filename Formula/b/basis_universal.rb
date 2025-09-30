class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v1_60.tar.gz"
  sha256 "64ac9363656dc3eb41c59ee52af7e939abe574a92c85fd0ba27008c4a7ec9f40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "528256b199323aa91aeeea65287838c0f416c350866aae486092e4399edcfe69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96434e6249de92e5397c362a061db58527d27934d0c6eb0c8dfca00a0e713a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e189d41590b8af1cbf3dc09edad394432df308cfff3fd3ec2b7f59364229f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11ad095bcfaed712c6bb0cad156195f547b62b25099017e42281081dd0625722"
    sha256 cellar: :any_skip_relocation, sonoma:        "255ab827520159d10a65c679cba019b737567ab0f6fbeeedf72328668b266ded"
    sha256 cellar: :any_skip_relocation, ventura:       "7968489b3cb67938213dc0ebabf094ac85d56cb6f7cec5f9815e7359f3efd074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cf5cb5d24db7ee3f074944845ba412eedf16b5aad753b6d01698bd2a886e706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7370a2812a7acea4e1b85530eea51b4c2d9c98db98e5cefee7e25e81abf710"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "bin/basisu"
    bin.install "bin/examples" => "basisu_examples"
  end

  test do
    system bin/"basisu", test_fixtures("test.png")
    assert_path_exists testpath/"test.ktx2"
  end
end
