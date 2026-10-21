class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://xff.cz/megatools/"
  url "https://xff.cz/megatools/builds/megatools-1.11.5.20250706.tar.gz"
  sha256 "51f78a03748a64b1066ce28a2ca75d98dbef5f00fe9789dc894827f9a913b362"
  license "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  revision 1

  livecheck do
    url "https://xff.cz/megatools/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a558fd59a2bc6dda63704386585f2cfd8b59c5457fa345206daa087e9533ec74"
    sha256 cellar: :any, arm64_tahoe:       "ea8d0afde706bd78b7ca8650bfcd7c91f9c68de7bec314148a0fb091eda4516b"
    sha256 cellar: :any, arm64_sequoia:     "9b4aa9f649ca34303ddb843f76c3f6851f1d610e7fadd80341bbde0899a3dc77"
    sha256 cellar: :any, arm64_linux:       "ad9043fd8e6a1151340b5e1cf6bafe0848806459148b19f6c664a90abce6dbf3"
    sha256 cellar: :any, x86_64_linux:      "76afb86498cbb3a42671ead4447bda03fa41f34cbd38b246df9b7d6b1c3beea2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@4"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system bin/"megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal "Hello Homebrew!\n", (testpath/"testfile.txt").read
  end
end
