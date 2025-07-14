class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.682.tar.gz"
  sha256 "eb3514e2dcefe8a4be7358ffef05420f071e94b47a02813916421cd9896b372d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd9ed2de2cda74f0f0bc9733c0a081201cdab588bb6d11a7605589cff0d2a5a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e89493534650e40713f9f6679cae18024e0d997eefbc698910c387da343ac519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fa194f745a522c27a61371d449e85fa2803f4980ef64967415f14e84862e96e"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c4ef6893daaeb7cd590b328e54597a2361ed33a10694d91503278969267f28"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ab36b3e7c993e098f041d33b4daa2cd05c8660fb66a63914573287f3b33cf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10038ca42bedaf723c795ea2e038595ba36303edcf297239339bf0fd7a9aadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c919e10f5a6d2e7cc63b558ab0a76733f3bcc464b0a086076338a0494983edfa"
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
