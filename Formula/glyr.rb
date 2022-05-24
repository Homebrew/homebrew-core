class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c46e7d37c47e8f8c6d8a2846b970e50634c00ff976b1393ef42cf3fa2119c07c"
    sha256 cellar: :any,                 arm64_big_sur:  "b0f1519a6dde37bf695753060e8f783cffae1ea40c1c0f7ceba3134c21ec3f65"
    sha256 cellar: :any,                 monterey:       "e2f4960f09eacefec2af4c8db792baaef983e2d9ca3d6019d8b3eed4cbe9a28c"
    sha256 cellar: :any,                 big_sur:        "70813cb0a175f7e1b470c334cd80ca97e255d9d1390c2868257ebfe159d85023"
    sha256 cellar: :any,                 catalina:       "0a32bfceb64d33842aee008ca44e823062589323777efee2f15f013f18017a08"
    sha256 cellar: :any,                 mojave:         "45d36208e031f97c1202824c6a6a0a9e97d777fae91ce7cddc3ca17c3168d31c"
    sha256 cellar: :any,                 high_sierra:    "fb3ef9186aae754a62a466aae16471049bdaefcc168106fc6f0097e937115524"
    sha256 cellar: :any,                 sierra:         "04cbfc6d3294d068b3a97bfb5235aed84b3e95478f8f3e873be17127142b07f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df73a2e61d24c31802aeead7557ebef37ce02523974b69b2cfa873faf9327501"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    search = "--artist Beatles --title 'Eight Days A Week'"
    cmd = "#{bin}/glyrc lyrics --no-download #{search} -w stdout"
    assert_match "Love you all the time", pipe_output(cmd, nil, 0)
  end
end
