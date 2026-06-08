class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.108.tar.xz"
  sha256 "0b68a2f3e123f27c32b971029658abaae00b4c3ae6e79c3f2c18c5dbbfe554d3"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0b0cbbfd7d0e29a4d35cbb8324c7858298314c4204281f7f3789ebf5150d8275"
    sha256 arm64_sequoia: "0b1d839629c53de7ac232441773022b2f77419ed11c6bdf67ad9bb905d4c2f95"
    sha256 arm64_sonoma:  "4d1937f0a86214e91a544b49261329f9823bee528b744f548704be2c8ab5791e"
    sha256 sonoma:        "cb2833fdb38bf1bee8a5410ccf5d5a9826c788ba2e4d42b84c682a7f05a89d6e"
    sha256 arm64_linux:   "481fbbf107f27a96f0af9f4210eb517625186398fd78f5bb04ce13278764133a"
    sha256 x86_64_linux:  "57f71c8ef976c7f3be7f27897b7a7cb3b9292e6f8ea5f804182088a035908d5b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc-gh" => :build
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
