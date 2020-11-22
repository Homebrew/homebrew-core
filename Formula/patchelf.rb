class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.12/patchelf-0.12.tar.bz2"
  sha256 "699a31cf52211cf5ad6e35a8801eb637bc7f3c43117140426400d67b7babd792"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/NixOS/patchelf.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e1fb2c4ce49b005bc2b61e1d7d5981b1a678d0b9877624396eca6bf2c339e7ff" => :big_sur
    sha256 "c614aade308b851a63d63733b7fd4756efe350fce9985291099f4ffaf7b3760f" => :catalina
    sha256 "754976c84c9d76186306b06981abb82a6787b0d5e8c5a329dd9017fab98af38a" => :mojave
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
