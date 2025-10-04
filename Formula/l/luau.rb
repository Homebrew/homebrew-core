class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.694.tar.gz"
  sha256 "da2ed646917c013dbdcb0cd109c660c5b8739e0977d907cb0c58e22b6c341296"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab8a87c2060bb140e00f363f8cbf1b21e03e80a28504ba9c67adad6acdc4a386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba696ebe1fc47fa854eeb94ac012c4d48bedabc735ef237ca2d7fa4105d3225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973854df9f746066313c2f19182cfad25e2a31dd46cd666e93efeefe6d5b461b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e28adcbadc632e8d550563f9118dc6a90ec91388cfef71f83b59a660327efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ba0908610188c897e672e31d6609c59c4d1ec82efff4f351e9a1e557d9b25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f34f752214006fb47fc8173dc60a625bd38ded75957c764279ebab9bf237ec0"
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
