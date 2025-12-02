class Pth < Formula
  desc "GNU Portable THreads"
  homepage "https://www.gnu.org/software/pth/"
  url "https://ftpmirror.gnu.org/gnu/pth/pth-2.0.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz"
  sha256 "72353660c5a2caafd601b20e12e75d865fd88f6cf1a088b306a3963f0bc77232"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "5d78afef8be0d57784a9fba9321b7939ac9e57492d9e1ff68192c465d1f001e6"
    sha256 cellar: :any,                 arm64_sequoia:  "ebea43fc620e5a3ca68ab4b1f05222b45ff99430e0572ad43a26ba2dc08178d2"
    sha256 cellar: :any,                 arm64_sonoma:   "2d11f5c8d0c953bd31407c69a481501bac6a990a0ca174304b0e9eae67028a6f"
    sha256 cellar: :any,                 arm64_ventura:  "fab1a0762b2bb6d4a662d7584e7e53a40c0c6e0a47173ee1b352ba5df0307d4c"
    sha256 cellar: :any,                 arm64_monterey: "43290f4af74260a674cffc3fa75fc0576a89e4040f57473e0601ff3052eca8e9"
    sha256 cellar: :any,                 arm64_big_sur:  "746ea3501c80f444585f9e8c532815ff97cc94e050d1f5672307451abfb1bcfa"
    sha256 cellar: :any,                 sonoma:         "42572a1ad204768fb92064ab80052ae590b6fb75428bfdd3211c3ed15518138c"
    sha256 cellar: :any,                 ventura:        "eb899862aa5c37f46b09b483a9dd2808fd3459f459fa0ebb715a56055e501e1f"
    sha256 cellar: :any,                 monterey:       "13d83d8a576279a5487fe65a8973ac416aacec3f2ca87a8ab3a85bb46b169148"
    sha256 cellar: :any,                 big_sur:        "ce0bf2885f2ff76922d2306e84e328b3bcbe5b3c8365806a66f75d5fce0568fb"
    sha256 cellar: :any,                 catalina:       "4e468eea8984b9eb265dcd2f1e10a12ec5827088986042cea278b24f1a4dc1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a8ac563cbeacea2eab01935e62cc4835b1811dfac30f9fb3c0d6a80cfc8b3f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cd52703b09b137d33237be545677ba50729264ef0ad34d5f4c3891bba86173"
  end

  def install
    ENV.deparallelize

    # Fix -flat_namespace usage on macOS.
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress",
      "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      args += ["--build=aarch64-unknown-linux-gnu", "--host=aarch64-unknown-linux-gnu"]
    end

    # NOTE: The shared library will not be build with --disable-debug, so don't add that flag
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pth-config", "--all"
  end
end
