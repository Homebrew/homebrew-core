class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.17.0/patchelf-0.17.0.tar.bz2"
  sha256 "45d76f4a31688a523718ec512f31650b1f35d1affec3eafeb3feeb5448d341e1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfd13c27623f1e5124c03f5709c549d10e3f2e0e905f60faef123850107508c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "440e305a3adc81f6b01cc42604b141ccdf5cee901220ad7bc940ddaf71ab55d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "346153244bb0701aec5108d11d88436a806109419fb96911c49ee4662d07ff0d"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d366b8048b40395f0e7330ce3d285ae0ab0079ba3dcc5be7957d357f46a237"
    sha256 cellar: :any_skip_relocation, monterey:       "b0cae0c81b65ed64330aa0ffbda185767d196416b983fc42bd37d6ed5302151d"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b25fa600076de2a1545d5436d775a0ef33dc6e39203b7fdb2a4ebb07083e5a"
    sha256 cellar: :any_skip_relocation, catalina:       "355c7597512ef6cc4bb26848d5ee47dbdf6f2bd706f55c6c9ef5048edf8eb056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb35e912221c30f6515caa71280a05b42ca9c51b7413b242582be0b9aea58d7"
  end

  head do
    url "https://github.com/NixOS/patchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with gcc: "5" # Needs std::optional

  resource "homebrew-helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("homebrew-helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
