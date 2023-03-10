class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.567.tar.gz"
  sha256 "7f7386ad06cccdcd70e7ce6dc75d55d855b82ad85bfc9b36342652162c7334ca"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18cc006938b20bd9a833770ad44ba50f4e3853f5e5d377909b207f3c7e3021ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e855348013d8db8f209c2ef46c34268ced9f25a17a93613784272f8e79880329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd40ab899d4557726fd4b36daeb57eb7a8ee8ba0c9769feaeae69e46d14d53c2"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0ddd1a3692549a2cc49c6e247860c3b44beb720ac73fd9b0f31ac81878caff"
    sha256 cellar: :any_skip_relocation, monterey:       "847e76387306e465094db96b596c08e16278edf6a225d1b01bce75d742be6cb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "81c154af8fc50aceaa1f996897c341e4655c12027980a6a68e3080d63e8a630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e4dc64ec884b8edee3aa82e0f30e154a6cfa8a28094d60909986cade97a92f4"
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
