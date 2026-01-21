class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.107.tar.xz"
  sha256 "4062a51a8d9b36252f0e42e3e81717f00e9a51671731e643f18d8aedca4591f2"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "838ad1f26d463ffec7096dcbb01df1235ae8152f0e98977a63f532f41c5965dd"
    sha256 arm64_sequoia: "9431c844eb3efde5fba6d9f57c3d4243a034f32c8867553178a909c0c78497e5"
    sha256 arm64_sonoma:  "3b1d007963a108d223890ecd6b040a07c26aa02b99be7c10678b56dcb24a6e1f"
    sha256 sonoma:        "6ca1ebe14f6ec2cd2bd74db0210e1cce6ef963098494dc75cc0bfbcafa0de61b"
    sha256 arm64_linux:   "ccdaaaaca05199b4a5753293990df5fda320c2a0f19dbb1b0c98730f2aef6882"
    sha256 x86_64_linux:  "17b67e1ea8bdc71774da5e09a60b23ce3198a09559b77676b62a7e1b170dbc40"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  def install
    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", "-Dlibedit=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
