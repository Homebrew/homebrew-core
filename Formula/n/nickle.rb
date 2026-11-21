class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.116.tar.xz"
  sha256 "8356a2c3d159a3f71a03def4dffa9d83244b0243b9b091dacf27122ec436906d"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "b4e3c57915f51007993c65d0a2b60f975a71a6268c4da9aed41d2e404f01f6dc"
    sha256 arm64_golden_gate: "c13cd22d50aa5274337b777e080d077ea5fdd8aeb363c91c1c42dc79f2c90072"
    sha256 arm64_tahoe:       "c398ace6241ff4c500f6a8621baa1723d9bb1c68d313fe3d2cd8023ee602e432"
    sha256 arm64_sequoia:     "c41d7010263b548c4bde473a434091c64cd94e7f27a806979af683d915fab78b"
    sha256 arm64_linux:       "0e404d0cd4039f23870c2c787fd459ccc561ba63ee188174f3e93e1fdb628c29"
    sha256 x86_64_linux:      "4c15213ef3e90011aa0537268d55df62e45b8ec7094d5b3fbba52b908a0836c1"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc-gh" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  def install
    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", "-Dlibedit=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    elisp.install share/"emacs/site-lisp/nickle-mode.el"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
