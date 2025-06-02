class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.676.tar.gz"
  sha256 "638b3055445eaff20153ff8b15ff52e0d238a3e764973edb43add3a5fd8d433e"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e3b79758a3621ff17acb855039082115c839374d1ed67279d28af5a7c3c5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816fe8034af9b505348d3839f1e1599f0af0806804bbcc24fd7142a9420c759b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a6db5e051f58e026b1552dedbab2877e465a919fb269e8ec0eba7eb62bd6628"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3ef3bff36a8ccfce9235657eeeabf77c4f8f55225c2fe1180a93adc653e11e"
    sha256 cellar: :any_skip_relocation, ventura:       "f742bc9d289ebc85a5926cc7de8953f3e101195abf506471a7f44922e088566f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878e71b776d1da5e4eafbf986732c45bc0e7b736fda51a2f08bd685644a67640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9edb16ddd27171c723ce1cad03319eb5a718416066a6354bdc2ea0f2da10ad7f"
  end

  depends_on "cmake" => :build

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
