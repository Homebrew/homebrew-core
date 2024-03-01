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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "038d4db7e90c261f4d16044ddfc2329a6136909f16d214f3205d78497bdb50cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69f5a23cc650319676420918e67d3cfe0818cb8e269f9cd09b48b8c2e999e7a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740346bd49d0db46096f75782ab499b34f5d788e3a1cd692063331564929f587"
    sha256 cellar: :any_skip_relocation, sonoma:         "64a139bd3a6464a09a38faf3384e5f25b406709a382c0760ab011b5cc2f5ef66"
    sha256 cellar: :any_skip_relocation, ventura:        "48537b8d715a9ca23af3ea0034d8608050eaabd2272fe39688430138cd6afc67"
    sha256 cellar: :any_skip_relocation, monterey:       "8f8c60d9ee75f14a0a3faa75da273693013eaeeb2db9c648d582a80fb1f6d42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3094a25d72fef409ca57f5bbc82dfe69b62c24cc8d994cd609c8e1abbc730880"
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
