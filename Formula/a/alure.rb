class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "https://kcat.tomasu.net/alure.html"
  url "https://kcat.tomasu.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"
  license "MIT"
  revision 1

  livecheck do
    url "https://kcat.tomasu.net/alure-releases/"
    regex(/href=.*?alure[._-]v?(\d+(?:\.\d+)+)(?:[._-]src)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "709b5d0a3f4bb2fed0a455b7fd023a31f85bb4fd93498f3a57fe6eaa552c78e4"
    sha256 cellar: :any,                 arm64_monterey: "be784a86bfdf46e17722ce8c2002a430495e70bd6627f13b2952c1147070cbb8"
    sha256 cellar: :any,                 arm64_big_sur:  "b7c2de932d9fa136dbecbd6b235c2db13e8fb4a46551be15cadf9f4ae58ab7f9"
    sha256 cellar: :any,                 ventura:        "941eb17380a74d487d84ac4a86c71709aad7b11b351c4418d10ca35985fa71b1"
    sha256 cellar: :any,                 monterey:       "42382cc1953f124c11b9ed54b255a88367991b52e20d000bb8575f4cab956121"
    sha256 cellar: :any,                 big_sur:        "0415055955d1281d292513b656af55869e32af09d92925ff26c74bcfea56487f"
    sha256 cellar: :any,                 catalina:       "3701d2ac280fd8ef5476343c348fec853397241cb2bdcaeb25e8a53b203d292c"
    sha256 cellar: :any,                 mojave:         "f2ae4fbf2822241975e66574e41070b298523e6321280bc83aff70d559db149c"
    sha256 cellar: :any,                 high_sierra:    "031b2eb61f6206879b76a7276298f1db9875fa996467327b519ccc6d1622a158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27631da30742e75d039fc709f8e437b22371bfc0859466a4bb4856f155d8f4f5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "openal-soft"
  end

  # Fix missing unistd include
  # Reported by email to author on 2017-08-25
  patch do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/eed63e836e/alure/unistd.patch"
      sha256 "7852a7a365f518b12a1afd763a6a80ece88ac7aeea3c9023aa6c1fe46ac5a1ae"
    end
  end

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/alureplay 2>&1", 1)
    assert_match "Usage #{bin}/alureplay <soundfile>", output
  end
end
