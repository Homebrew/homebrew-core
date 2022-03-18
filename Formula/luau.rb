class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.519.tar.gz"
  sha256 "4fbf3b5d258d1d12138d8f29b8c557192cc83ae89a707f06b18011b2757f50e1"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5cea2c8d3a9d1902a4425fd1e4e82d650fe699f6296855fc9440eb7d282e976"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a4f989c0168bba3c3869f9b8e2dc426c1bea5ff18cbb8e90bf0739ba87fcf62"
    sha256 cellar: :any_skip_relocation, monterey:       "046c46228c9eda79f2098c2f9b9af96f0d5acec6af8930c0081319696de6bdfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bb80735b13106149cd0252a040a005a9731bfa77d8f1d18447a261b76d6116c"
    sha256 cellar: :any_skip_relocation, catalina:       "d8c58bf4c74d8507d29c973210fa33b4d505ed7a5eea08c763e33a782af7bb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b3502833f4cdcce8975c22e68b022321c184f3c244f44e7b546831a70e870a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
