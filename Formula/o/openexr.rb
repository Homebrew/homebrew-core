class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.12.tar.gz"
  sha256 "a455779c389f65c64220d45b63ead2900081e5f6337cdf93431cb1032c3e2686"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e188e596db9bcb65223fea90a297d92da7c77b02998ff62e714277a4417818d3"
    sha256 cellar: :any,                 arm64_sequoia: "15817b3ce3a16042129c148e657567da5e099f56d7a728e7ab0213837d7a37a2"
    sha256 cellar: :any,                 arm64_sonoma:  "6ae4cd7a31a31a7cbfb5f9eb8410bee098ce330acf2ca3be521214fc1be9f48f"
    sha256 cellar: :any,                 sonoma:        "e9909fb8620d42f5bb0ea6581fa48850444b7d5f719bb7941f7a596b89a62e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a0ebe703aac350b1477fa2cd57fc0cad81f4f5a7d8915c3d92cbf7aeac09ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77db77351655b2f139580ecaba76dcd0f374ae21794f2330c805ed0d356f3809"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
