class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  revision 3
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d430c87fe1bdce8278c35b384fdd710d7b07bb6fec13676e4dfeb209b7463075"
    sha256 cellar: :any,                 arm64_ventura:  "42c00e005437933df6c35e1b02279574a5ba02cc291197e219dc7abba000562b"
    sha256 cellar: :any,                 arm64_monterey: "ebae7383bbe2c1bf3716c50bdffd0f81456ac5c08997ecea166562412dbc9905"
    sha256 cellar: :any,                 arm64_big_sur:  "3e891436d6c9bc418ecad989cc379f5c277591b9592f0f9b0246dea586f77bc1"
    sha256 cellar: :any,                 sonoma:         "1ce9c687782c8ba039847d71a7aa3bccdb5f4ea95a62311145c901a96540f061"
    sha256 cellar: :any,                 ventura:        "7d35d0b4c27ad0678118ce7773fee9345332fe37e11bbced91114a05f9aa925d"
    sha256 cellar: :any,                 monterey:       "ffd52e3ccf757a8368532f32564a7f33874af52cddf49a3086925c9dc964c8fb"
    sha256 cellar: :any,                 big_sur:        "d4a621dea543241bb9fbf00f7bb214ce9184e1f1ef50d319a9bd5261e70ca931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494ec3f0a79bedcccda61162763724eff9ef6cddfde6241a69d74d6c65a78ce3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "mbedtls"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
