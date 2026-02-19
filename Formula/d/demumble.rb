class Demumble < Formula
  desc "More powerful symbol demangler (a la c++filt)"
  homepage "https://github.com/nico/demumble"
  url "https://github.com/nico/demumble/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "29501fbd5522820a1672aea0292105b8706899e4e4b283ff51c126f79b3b2c41"
  license "Apache-2.0"
  head "https://github.com/nico/demumble.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "89efb9561af007453bc3c3ee5704c1958b917ad339ba809f9fc82ce6e664af19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9d309fe6c5f674b30ec35a6e96839df670025d244eeaa5858ec82ec344e0088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e34a9ee99465347fe0a36b113f79cdd98999262e29101b5a9699f0c190dde14e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a474a2fcc23b8ba6b7793248e428d1540601110a208e1ad0667fd2a7f8ed9751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5313425d4a9c7313925d1d36284a65d02ad1cc1a05ec63f3ae955bf70f321e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "82fd0c99b4a2fc69cfb3992bbd6d79d18db9426050f9a78d3fdda12e81ae0982"
    sha256 cellar: :any_skip_relocation, ventura:        "3ba5801427e3a2ac99c397cb763935a7634eb7570e160d6b2f6024df4242a5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "681cdce237bff42a2aa28ba656a68a7d3be054238f835851d065527226b44d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12aa9a00e75ae42f67f02ecc5be3492d5bf8e232052e8a69f16f870d8210a5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e10f9d48f1ae69c4f432c8d1af2a69617a607d8f305cdf277062c1f764bafea3"
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
