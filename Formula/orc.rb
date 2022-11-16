class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.33.tar.xz"
  sha256 "844e6d7db8086f793f57618d3d4b68d29d99b16034e71430df3c21cfd3c3542a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6835572f307c664d32dae1adee85cb591ce87ebe5e043e3d1b96daaf490ef9d"
    sha256 cellar: :any,                 arm64_monterey: "1d6e95c2da86d9a1c3c7c7e0f834f41d3d5b72e08bec0d4c92b7f88ce636b797"
    sha256 cellar: :any,                 arm64_big_sur:  "ed3c9ae06a684533844d3f9409eb05142009959f04fede00d81ce71c82f7e55c"
    sha256 cellar: :any,                 ventura:        "72c8c25a55e389d63259d711dcc19b45302c4f0c89c825267eb58422062dd86c"
    sha256 cellar: :any,                 monterey:       "c5976c028541b8b6bcc24c6f9456b7cbd76755303f1c32dacdd20276f90916d5"
    sha256 cellar: :any,                 big_sur:        "f4d9c394d9bd5af5c20a342725d453087518655aad69def048c87e399036e611"
    sha256 cellar: :any,                 catalina:       "b09113fcfd2c00406b6df037b700113565897b865acc01a77b96bcf67a3ac1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72446572cc450af4a871a56f77662df569a49c4ab84d40a8cb5ed3011c214393"
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
