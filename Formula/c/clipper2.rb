class Clipper2 < Formula
  desc "Polygon clipping and offsetting library"
  homepage "https://github.com/AngusJohnson/Clipper2"
  url "https://github.com/AngusJohnson/Clipper2/releases/download/Clipper2_1.5.4/Clipper2_1.5.4.zip"
  sha256 "e5cbe4acdfbd381496feacd5692110f60914ce2998e7350b124fb11429574f75"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(/^Clipper2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c32c400b83531261299a333feafd72ee660ec63811bac621debed98d986b04b"
    sha256 cellar: :any,                 arm64_sequoia: "5344952baad694ee32003946b5ed28a8212f58564a79df0ee97a245a2e35fb31"
    sha256 cellar: :any,                 arm64_sonoma:  "dab66cd4bfc560cc95579a0586f44cd3a8a6c477abad07e5dce0d9812a97f9db"
    sha256 cellar: :any,                 arm64_ventura: "c3634a45b7e445d258db0179b7946b08e4e746ec3d04c8f4c9a71f6d351a99b7"
    sha256 cellar: :any,                 sonoma:        "e488dd77e4e22dcc5c7031904749e89f67483e28d9c3e300674d4907ebc610c4"
    sha256 cellar: :any,                 ventura:       "beeaceb4432c6aba698d3e23f55e35f5aabc4aeb2a69323a94791b37b9e73532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3827936a12835ab57ea26493a4b38da08705e0d0e743384a58f80b7817cf1acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8346e821c65cac35259db00c4a43d56bd53dc4cc581bf0922b963968c2b9bd17"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCLIPPER2_EXAMPLES=OFF
      -DCLIPPER2_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", "CPP", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "CPP/Examples/SimpleClipping/SimpleClipping.cpp" do |s|
      s.gsub! "\"clipper2/clipper.h\"", "<clipper2/clipper.h>"
      s.gsub! "\"../../Utils/clipper.svg.utils.h\"", "\"clipper.svg.utils.h\""
      s.gsub!(/System\(".*"\);/, "")
    end

    inreplace "CPP/Utils/clipper.svg.utils.h", "\"clipper.svg.h\"", "<clipper2/Utils/clipper.svg.h>"

    pkgshare.install "CPP/Examples/SimpleClipping/SimpleClipping.cpp", "CPP/Utils/clipper.svg.utils.h"
  end

  test do
    system ENV.cxx, pkgshare/"SimpleClipping.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}",
                    "-lClipper2", "-lClipper2utils",
                    "-o", "test"
    system "./test"
    refute_empty (testpath/"solution.svg").read
  end
end
