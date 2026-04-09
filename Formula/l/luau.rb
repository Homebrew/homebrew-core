class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.715.tar.gz"
  sha256 "e2d376447f125ee96c91e46adfee5bcd5760d59f75a4c70967aca2d5e649e352"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a3315eb01b589cefce19da18f034f53488f8e48549644d0d26fb1e16f09f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08bc81482eb5984a6ca3015f98c46b097ca980a84f02832a3bb867b13251246d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac7bf2d0277fe0e9dfcc511d75c8a76d1089d270124ec3633048ca3f8409ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4184411c97f82fdc8fa8bce6605a7fd0e26bd8b8966b2202b9fff0eece617d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14a89d873f77d5a0e0e3d95ba53c9eb5db4fd51ffb5b3fe46ae6938cc8c31e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dadd2647aae1622b0849cc744bd9cd0cb852e478d2d0adef9f2df28336d290a5"
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
