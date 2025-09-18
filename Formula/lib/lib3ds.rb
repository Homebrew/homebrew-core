class Lib3ds < Formula
  desc "Library for managing 3D-Studio Release 3 and 4 '.3DS' files"
  homepage "https://code.google.com/archive/p/lib3ds/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lib3ds/lib3ds-1.3.0.zip"
  sha256 "f5b00c302955a67fa5fb1f2d3f2583767cdc61fdbc6fd843c0c7c9d95c5629e3"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "05c4539d63ece4173e11e64c12337fb23165bac92574603467512f73c770fb2b"
    sha256 cellar: :any,                 arm64_sequoia:  "7cac898d78de339d70d5aba02ebdfc2703b341f251206f8cb1ebb6c35eac984d"
    sha256 cellar: :any,                 arm64_sonoma:   "3eb97f0b621af19c2c00dd8590357fe234954bbaddc81ca0d43323837ce1d50e"
    sha256 cellar: :any,                 arm64_ventura:  "065e64a374733b5c8fe9a37c2897e5c366bc2e41bdbcc92708e130eb0a446f88"
    sha256 cellar: :any,                 arm64_monterey: "630075c7c6f6a5d80d39592ed47c6f6a7694a02f32eb5ac0f7de12ddc15d4a56"
    sha256 cellar: :any,                 arm64_big_sur:  "2959476e3f2e5a95ca23aa6a9fc4b11f9e8ca202e460d6b00ce2906f043c8936"
    sha256 cellar: :any,                 sonoma:         "9acd8d134ef5efb47d11722256f0012be94562994fc87f70f89a9a13d9bb72ed"
    sha256 cellar: :any,                 ventura:        "43e5029413555b545a6b4177acdc9b254f3e6a82251ea5bded95dfa5b7f4d93f"
    sha256 cellar: :any,                 monterey:       "745bdb83e2fd03b6f96e163055971471f3f4e1ef6ea465adcb765e799b9a01d1"
    sha256 cellar: :any,                 big_sur:        "175e42127a596271ed3347b35eeb8088d684b1b46f6efa4d1bbb8d8ef9776605"
    sha256 cellar: :any,                 catalina:       "0a5a1fdac0c459e011ef64556c872fdc61678ccc7e06d507239d03729a0a8613"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f4f7ee247f3625649c17b51c43edff23d98d7d3e84dc388a509ab1775ae43d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7adf7c63871e56081abf7ecbf0327d77970aa925812d04082152d32a13d229e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # create a raw empty 3ds file.
    (testpath/"test.3ds").write("\x4d\x4d\x06\x00\x00\x00")
    system bin/"3dsdump", "test.3ds"
  end
end
