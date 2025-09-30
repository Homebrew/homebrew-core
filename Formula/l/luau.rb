class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.693.tar.gz"
  sha256 "8843dc7d0a961b289c7e71121ca12db7f2ee41b17d428c59f088789fda9632bf"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71c7044542043ace1b5a2bcd06c91407e54d65017dfb9eb228a93bf9624fe19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a550b8a4d094a24c388afb17fca55293d4c74a2a9678adffd8b55287b3a1622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16598aacf62b3f9f5034bace774c3fb575f25200eca7c948981d3d410ab34fa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "10f0b49ff9538f55275284fdb42529dfbfa7af55b629ff07378bfa0bd4540259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845abfcd04190de25c1dda1710e35479594018ab987fbad113fa0b7cf3da74e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9886f566c697531cecc50b33e494de9fe3b318a0caf2f404dea7cbe305d40b4"
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
