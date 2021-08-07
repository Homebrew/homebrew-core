class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.13/patchelf-0.13.tar.bz2"
  sha256 "4c7ed4bcfc1a114d6286e4a0d3c1a90db147a4c3adda1814ee0eee0f9ee917ed"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d600655f0357e24341513f4688532d920baca6c302ba8be53b4a8b84a9db1bb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "d83931e807f58c62f0b321b9523d16de6602415f0e19b3702d072b4dec382cb6"
    sha256 cellar: :any_skip_relocation, catalina:      "344c4459a5b03099308520eb7ef906242bca77f08ac1660ac61b74ccd7871b1c"
    sha256 cellar: :any_skip_relocation, mojave:        "906cd9171c62947d8133b990bbc15ad7803bb5623f5b72332fa792a01c9634ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73b17a4a11801b06958235f32423bd735be9a9bf126b43499c552f2c9ac489f"
  end

  resource "helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  # Fix unsupported overlap of SHT_NOTE and PT_NOTE
  # See https://github.com/NixOS/patchelf/pull/230
  patch do
    url "https://github.com/rmNULL/patchelf/commit/6edec83653ce1b5fc201ff6db93b966394766814.patch?full_index=1"
    sha256 "072eff6c5b33298b423f47ec794c7765a42d58a2050689bb20bf66076afb98ac"
  end

  def install
    on_linux do
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
