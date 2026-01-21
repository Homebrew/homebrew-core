class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.705.tar.gz"
  sha256 "2cc5274766acf1456c8072d0374bfaf3068c18231007b77bf24ea884207dec78"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b5917ec0e2b5641af29588badc3d312818a6b1eea6ed3c7a674ca8d86218e5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee93205e0bc98531142b6e7788c5f810974f42b8ac66b49fbd2e6dfc01cca115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a0f31e01f573e9cd3b66c7498ec5d29678e31b36362540c3621985d11f2b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5e5362d44262d78d42886b96fb72563cf07c208c45dca4547c96dc07509fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb0c700f6b3956adf5eaabbabed7f45b0ca1131ee582c53b4a4b29b625df4a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f468d2be1c62015fe2224a39ba842b5f0eaf2217906d603de965393d905f6eba"
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
