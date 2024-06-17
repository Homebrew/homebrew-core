class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.630.tar.gz"
  sha256 "601938ebd428d37c2bb10697500bff4fe304f7c0651cf64721b9dc5600a30ed9"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab7f7a2746810524c3836a0277a65e0aa5c214346a74d21754aa178affe14b68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483042517b8974ca01da537150043dfa30370dc2c118873b19c0aee8ddcc252b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb216affb5150226e52fc69e6f608e7f3db7d28b21f718dc1550ef4a07ace16"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d63477f1a5bca399413dc496ebf24f17f35dd3a613240e51ed9793d05bbe52c"
    sha256 cellar: :any_skip_relocation, ventura:        "1acc794b506116c4884c1bde6775f41582088f6fd86946fde2b076d76218f803"
    sha256 cellar: :any_skip_relocation, monterey:       "845a93a168460932d0db8d55b831fecce044fa10043ab52c3b8483845b4f4b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660d31efb151be3a507538bf61e9a86c0c13defd703c342ca693e08fde26ebbc"
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
