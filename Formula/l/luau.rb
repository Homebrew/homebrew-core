class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.730.tar.gz"
  sha256 "448d720df65d393f4c61c7d2b2ddde8c772de55c23760603a9ada43a752aef70"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29081ad7d4f327377fbe9bac587f119234a4dec467ea19f6831bb1c227207ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9723adb7de7c25813ff6be994abadd2f49ab0ec31d195a98055fb030c5c543cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e248ae2a8a8365442fc97e1bca78e0dd0fe81f685e4d4fad6a3622707721491"
    sha256 cellar: :any_skip_relocation, sonoma:        "3749ba9cff32c1666a572d35aa306865eff15d99b80b0ceab9c68237dd0ee202"
    sha256 cellar: :any,                 arm64_linux:   "1a728d7ce236721598dfd01543245c05f2e86ad90318d3c1241cb80ae92e8fa4"
    sha256 cellar: :any,                 x86_64_linux:  "319bbf3954368a9f24c5282c445f0391b4e71be45a79f9c9d052f1e40e0db258"
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
