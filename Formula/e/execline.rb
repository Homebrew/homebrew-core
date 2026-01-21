class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.9.8.0.tar.gz"
  sha256 "d05e0b75cc21841692119c7a7838163acd7f05318bd69e779068266daa7ce91f"
  license "ISC"
  head "git://git.skarnet.org/execline", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7e344ad336bf5e8d6e1b015bf31b713369d864ceaa47c9e5488ed779ffa67a3"
    sha256 cellar: :any,                 arm64_sequoia: "80d7976ecd545eff02d35fee0f3b78e872829eefc995a5a02e59d4ea619b7e5f"
    sha256 cellar: :any,                 arm64_sonoma:  "b8e788fab61d14394ac407f73196055c30416fad63b0da28887b25ef66f94d75"
    sha256 cellar: :any,                 sonoma:        "7de25147b344591d623c57ba3f918bc7fe41d8ea37390a4964dea38b2bc69b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e03b42ed07a004b26b80a6c4f04d105f55cfa9a0e87cc7fa42efb54f3b3eebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590fdb671f78fa114dd979020ea677f040dd5b66b78de44eb3e5ffb035357769"
  end

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")
  end
end
