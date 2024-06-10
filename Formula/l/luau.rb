class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.629.tar.gz"
  sha256 "18b04e673a4e450872b57e1881fc54615f8c18addd8336b3e0b20df43562d50d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f324966a4f8d0c744adfd901cc0ad45d2343e6eb2cf5f120c8ed5487c1fe6da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29491509f9d4d73279c92abdf27f3ec24ecc9b02ecd8aab0ab02a55768f4fa0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "170e9964dab4834e73178daa2c3299c5363218d87ac9ff2103a95549676bb771"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef8ce7cbdaaa50ea5c5a5e5f10ed50af724f27e76bbba4124d7b9d1d08b1193"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb0253cb0664d4ac6a9898fcb408c5933958583e8bd7397167c5cc482f98017"
    sha256 cellar: :any_skip_relocation, monterey:       "2de9cc8f42eb57c870f02bd02aa6c088b2b20d4d4df02521df54ba78742d24e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e2cf02fa385edf21091e33e66bfef67b74a9cc42979963cbf97d154fea5e06"
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
