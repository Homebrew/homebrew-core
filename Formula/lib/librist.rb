class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  revision 4
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8b52b9e6646458bcc6e01faad09a5c1a1ea7f21fc19db0b0d594c8645670d7a"
    sha256 cellar: :any,                 arm64_ventura:  "c34b9b3bec932b5117ae23940472bedea37c04a1ed25fa7c4ab5dc69b7adc121"
    sha256 cellar: :any,                 arm64_monterey: "f3749618b7e7fd77b3add6130f6e6c6da636557d59f572f50e217135ab9a4bf8"
    sha256 cellar: :any,                 sonoma:         "c611e76dd56a9bad2e6d363204bd26c0f3bb44c1ccc9af2a4cf1c268e344a9f4"
    sha256 cellar: :any,                 ventura:        "b5cc249c0c8598b51631a54077bf625a465e1ee5b41b319a75dcfcfa50330cf9"
    sha256 cellar: :any,                 monterey:       "52e7fe15d152bf90d2e55e938958d48b2f870e91789396bd6e898c23c1c9df27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a77e55467dea8a362cb494e2628b897d2cdbcfc65a3230d1733161ef27dc580"
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
