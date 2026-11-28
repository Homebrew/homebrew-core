class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://xff.cz/megatools/"
  url "https://xff.cz/megatools/builds/megatools-1.12.2.20261116.tar.gz", using: :homebrew_curl
  sha256 "2c8cfbb41eabf1ffac92f08f5b3aecb361bcfb9c02ac258769fb5e3ba2f15b84"
  license "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }

  livecheck do
    url "https://xff.cz/megatools/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "f1389c169f8f84d9e20a5ac915203f3ed7d161c5e27915277794fff96815f43c"
    sha256 cellar: :any, arm64_golden_gate: "b8de0384ada644416dcab2cb3a8f716ac97264fd3a04fbdf8087fc546c236462"
    sha256 cellar: :any, arm64_tahoe:       "4bd6ff739b042cdee5e6b516af1b0ef91dc57375f5ca40d7bc788aea4c2c1a95"
    sha256 cellar: :any, arm64_sequoia:     "1025d6bd6f7e94990ac89856ce9ff9a35414d5335103ad56f9856cbc0d18f4fb"
    sha256 cellar: :any, arm64_linux:       "bbbe5411eb2552e0310bbf2b0015feb41eeae556e789387c171c3660ffd6f1ca"
    sha256 cellar: :any, x86_64_linux:      "b955b4b4301d1c111b3b025073978442bd27ad276bf51f590f175d303d418bbb"
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
