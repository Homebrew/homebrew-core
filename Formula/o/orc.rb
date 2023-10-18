class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.34.tar.xz"
  sha256 "8f47abb3f097171e44eb807adcdabd860fba2effd37d8d3c4fbd5f341cadd41f"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca35b5b8f887473134490ed67e7e9eb3e4cc9356319b04d95fdc52237c5a18bd"
    sha256 cellar: :any,                 arm64_ventura:  "4809e52484b133ae5d75d871f1226088af8da0631627c1a243f397cf99cdcf7b"
    sha256 cellar: :any,                 arm64_monterey: "a143b0d08a78bee0f6306857e45950fc3f2b1124928909dff88ec41ddcd38dee"
    sha256 cellar: :any,                 arm64_big_sur:  "b81aea2123348a12626926c9ba05a58b9948c6e4ae0d03936ba1dd59a966a54c"
    sha256 cellar: :any,                 sonoma:         "1642d1c88b5721c8f7cf542b16ae7d25fa704d4ae613278e73f4fc3e32537bdd"
    sha256 cellar: :any,                 ventura:        "4bf03b2ca55f88af8f0220ba12d837654f225f4fc975ba1b2d1e5c60e4b7da5b"
    sha256 cellar: :any,                 monterey:       "5e26dc4f953cf313d803dfc4acc1747a4d13464023cdde4c6cf91fe313a50239"
    sha256 cellar: :any,                 big_sur:        "ebbfe4bc460db54bba1c74a6839c7520ca77ff1945b4f318f26dbcdd970f8321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e357c1fc016d6d5af0cc4e85aa93492115ace878a6f7d0a3d835d60ad520f3a2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
