class Demumble < Formula
  desc "More powerful symbol demangler (a la c++filt)"
  homepage "https://github.com/nico/demumble"
  url "https://github.com/nico/demumble/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "5546681f1997da4363eba464be49c1cc0af865d335e5e0990097ace04c37bc9a"
  license "Apache-2.0"
  head "https://github.com/nico/demumble.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16ccd6311a79e9f37a2b048427f5589e507d029ddf4b2e0f586281d2e7ba113c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9fb3bd64941ebfd31013c9190f82123ce1c03994354dbf5e5b869f8915e147c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8d076ce6d470fa889394ed4f49fbb4d03607f43b96aaa35673c43063377458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a1adf034988625c2b5a332e206653999e2a48be3d5b02a30438bf3ab6741d99"
    sha256 cellar: :any_skip_relocation, sonoma:         "54aec5a2a34dc242d4538ea583b0eb42569b1bf303dc34f38e62814e2b7a3558"
    sha256 cellar: :any_skip_relocation, ventura:        "549c484ee6571ad0e1bf06da73eb3c752746661024405ace54d574c11207dee4"
    sha256 cellar: :any_skip_relocation, monterey:       "02d1bf2b1a481e3f092995b4d908243f5bdae26fd34ed3ad88ca0318a5250410"
    sha256 cellar: :any_skip_relocation, big_sur:        "d19a7b96469c227e0ef8d161a65bf9b1b5d5046978afe945a77579326a6779ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2adadec0de7c1f55c9b0b858540be94cefa9ff54985fb4eb505feefab3082ef9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # CMakeLists.txt does not contain install rules
    bin.install "build/demumble"
  end

  test do
    mangled = "__imp_?FLAGS_logtostderr@fLB@@3_NA"
    demangled = "__imp_bool fLB::FLAGS_logtostderr"
    assert_equal demangled, pipe_output(bin/"demumble", mangled)
  end
end
