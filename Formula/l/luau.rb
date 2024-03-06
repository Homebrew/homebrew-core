class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  stable do
    url "https://github.com/luau-lang/luau/archive/refs/tags/0.615.tar.gz"
    sha256 "264192ff1cb1bc3d5c223e5fbe9c4c628d203e2ac6ff72100e09640f43f60a60"

    # linux build patch
    patch do
      url "https://github.com/luau-lang/luau/commit/9323be6110beda90ef9d9dcb43e49b9acdc224e5.patch?full_index=1"
      sha256 "4da5d66d0b808f1c403d1d16a227c7b43f7efd1553113f55675ab4167b2c9d90"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fcea23e431c3dc8ce07a6cc47182dba7043c274e12c4ac2daec889383f2ed3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e51592610773629eeafc90db89239f7643ad2b533c8a2b9dce082dd5df4590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e2d7342070bce640c2ebf4ac7b9a08e9d5cec5872fe5178f3a38c66617e6ef8"
    sha256 cellar: :any_skip_relocation, sonoma:         "19e3e13dc59e6c0d1f70786e869cbb99c8201936757cf25c3cfeade70ab04149"
    sha256 cellar: :any_skip_relocation, ventura:        "d2474a7d610c84765e1c07c269c1e95928510d919ed6448fc6cebf0ff3ee7430"
    sha256 cellar: :any_skip_relocation, monterey:       "dd522c64e7cc60f0d57feb519e0450db196a640f0540d154e69fb25c650bd77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256cf44e65097c197b2608a998261cdadd5dc1494516098e6de538849a0d6070"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
