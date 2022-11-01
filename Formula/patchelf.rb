class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.16.1/patchelf-0.16.1.tar.bz2"
  sha256 "ab915f3f4ccc463d96ce1e72685b163110f945c22aee5bc62118d57adff0ab7d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e30c273a08e1ea134d0bd9f03830aadac46a9f1484dccf448a09f421b9f5ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7bbdf66c3941fe8be7aee359bd231e67df3abeccf6cbbed0a77f4b9c12bfb07"
    sha256 cellar: :any_skip_relocation, monterey:       "1d14f85fcb1f46326f7dae25cf18397965d12dfdc95f3915de8519367de879c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd6411bb05f98918c4f1ed841e6e979521a1ca089fb18192032d839002edce1"
    sha256 cellar: :any_skip_relocation, catalina:       "4a4da58c6ccabf3fce93afd2349480ccf0410f143df381392cfc9ed052357f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f489c4a38245cf50c4a658517ccf7fcc90a16bbb9d3870de6cf296796b69e9d0"
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
