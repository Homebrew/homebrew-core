class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.717.tar.gz"
  sha256 "c3d0c210ae650b52e40015bfacf0d04926fd516b8634b14ad1e64d620bedc8dd"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087437b65e8d76ae68930f63173aefb8e0fe0762f581ee5b7aed52cc2e78a3ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c2bbcb718cc15166c3f235f75ea15263425908c360435e5526df6a7841a3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a6e019c9128337c2b27272a48b37b3fec42e2a408557f7ae4622548f11337f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d473aed2ce7d948e6657372f6aa6039be6bb53b1bd00143b1ae1f0f19c97741a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81dde22b26d82e85da2878a2ea8c72986d006999db4a0355a916ddc6694df41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6824a77a5b66fbf08e098c9e86f8350a6acfa7d3656f6d43acc0ce72cbf82254"
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
