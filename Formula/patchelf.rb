class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.17.2/patchelf-0.17.2.tar.bz2"
  sha256 "bae2ea376072e422c196218dd9bdef0548ccc08da4de9f36b4672df84ea2d8e2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df237f718647a8c248b2112f0b989ffdf5ac1d3261354cef4b5d0fef9425696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb45ccc30e36a71c817a3c2729300193830cb1dacd7ec169008421290a4d2c15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff06f5e48778635bb7376d3f1f331f21a656dfa450d374fdd608cf0d759ee6ce"
    sha256 cellar: :any_skip_relocation, ventura:        "7c3ccbd8364e10beb8fc36547fe9464f647301e2aea2d47754e6cbcf56b9f0c7"
    sha256 cellar: :any_skip_relocation, monterey:       "0c4b905a8aa52108d722867b528317001a2cc70a81661ee0f4828a5be6c260d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "26a100a5ed000ffa714c4c8442e5d2786014b7ece03d30be1564fa00b2e4eacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39f33251bdcfc18e7cd0113bd8c1080c6f868e64f10f9bb5d0a9afb3f66c64e5"
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
