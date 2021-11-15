class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.13/patchelf-0.13.tar.bz2"
  sha256 "4c7ed4bcfc1a114d6286e4a0d3c1a90db147a4c3adda1814ee0eee0f9ee917ed"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c47328128ef6c7bf407b3ba9bbdffb0100edfdf5f0f468ce486d0e592b7b573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2c5ae0910087e5d745179a034d334b994d48a54398deab50c7efa389d0ad5de"
    sha256 cellar: :any_skip_relocation, monterey:       "cfabb87851b51b722fe08e72cefa869b57e09eed314c7cdc992d42ad39e9141f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce62acab3314332cc248a08ba8285882a8d33d976196f1cfb8b1d6553035635"
    sha256 cellar: :any_skip_relocation, catalina:       "5a42eb843bb076dd938eb114e8e751ee871ca04f1db023051e0ae546b5e9fc79"
    sha256 cellar: :any_skip_relocation, mojave:         "d2f37f5a48c8054def582fd9cfda48b114a6f4f3287d45719d0d9a58adf6d5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d839514014027d8222d5de10868a4ba754c3b4cf5f502bfc791fc4d2eaa705"
  end

  resource "helloworld" do
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
