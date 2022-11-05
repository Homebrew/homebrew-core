class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.552.tar.gz"
  sha256 "c638aee88010197d7e6f22e592fa12360e38a69f54ed91980b11ac0f89676db5"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f6d9d9c9e0439481f9d480e5d946bc61b9147e7af653b7f1e37b87a0e38586b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f33f89defa21e781bdc8d1b027ea7407544cdf1a00ddc773d64288a1e1bab23"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfd7894482f03ff5475d3fbd9414ba38895a9df178fffc6f1b074f52d959711"
    sha256 cellar: :any_skip_relocation, big_sur:        "3223f61bf9816a3634a41c4d5372e326e152429dd15417a44782992a9484911e"
    sha256 cellar: :any_skip_relocation, catalina:       "ab8873e6c34b070ca68c5092e7cac9632984164e439908c5f25d0d25b9534e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ba9330ade8e075bd6a655928c48f3ef94dbdaac1de4064b0d7cc8bc9a9de8a"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
