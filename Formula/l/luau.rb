class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.659.tar.gz"
  sha256 "99fb48950a094340c3cdf0d88376b9ddb4e06b3939bb008d2b0170bcb9f3ceda"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b49b16fa505cfd3dc3695a26db3459008de01cef51c60b47e7bb47dd085bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6514d91b0de4e86078b1a50967718fbb937d308a1e1704660a2b94d67fff4ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23fa57ccfdd35a02a24f1d6569d6169b7cc88446b163e8cd75bcc93b43f20c17"
    sha256 cellar: :any_skip_relocation, sonoma:        "85099f244f7ab6e5d582852f6b43a0ae1f19c272cd7ba9fd27039d2e5aa79082"
    sha256 cellar: :any_skip_relocation, ventura:       "3aff29fec90a116fac859fc321330eda98dc26869f92964182b70223684d7784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b8a5e55c71660fe4d9966fcdd039f149ad87253614009f0e096df5ecf63414"
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
