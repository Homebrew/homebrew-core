class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.623.tar.gz"
  sha256 "5a72f9e5b996c5ec44ee2c7bd9448d2b2e5061bdf7d057de7490f92fb3003f40"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c12f6db3e8e69e1dff8623b87454d07b05e8784992b7f4db899f52b6ab204eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c44c0b66c840ac5a4902ea15157703b1174455aef6832f590fb9c142bed8c092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5de8236c4f7c31352caf6f48d2f67c91c6b66f885d5129dcc77e956cd4b6ce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "39dacc41241d67fcd06a13fcdbca2ac7519a63790a9b61f8f06b643b7edbc224"
    sha256 cellar: :any_skip_relocation, ventura:        "942a38b649e67ec5ca5659710ca0301dd58bcdd8f5ad440558034b6662f8ef7a"
    sha256 cellar: :any_skip_relocation, monterey:       "75f5f4edc62a406a211847e49a56fed5bddec07ceffa4a483f3ae446d3fbef12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2adf54c748f39c6269837dca360de17a391d0e76fd3db4282c5ad906a14caf8a"
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
