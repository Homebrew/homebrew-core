class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-18.5/cdecl-18.5.tar.gz"
  sha256 "e4e212db3f997a9afe629fa4868062e0a92d6dd79ff374eca07b331220936362"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2f274ad2494839a778687184c6ca3e9198fd683a5fd2bfca3b46fbcf1df5f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7beca9265e60378772ef71fed480cf2167e132e50d13ffd3d8b92f9c569725ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26117d6cd0032b763032c2c785378b6c2f9a3862ea20917093db3e4ccbb73b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91d922ad48991f96f16944eccee5f54ae39ed8d320291a7b9f6931216e083d4"
    sha256 cellar: :any_skip_relocation, ventura:       "985fcee26f14ad895451b660826f8fcb1e353af4388dad3c612ead2841f566cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886a5496e3d7a8567c4491f4f10f50c2c321388dbb71d37ce1a7430ca9e3ec5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37cd9a2dd7818ea45acfe2295e085f2c92381f83b97339ec48760b1685d827e"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "declare a as pointer to integer",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
