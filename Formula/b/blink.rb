class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://github.com/jart/blink/releases/download/1.0.0/blink-1.0.0.tar.gz"
  sha256 "09ffc3cdb57449111510bbf2f552b3923d82a983ef032ee819c07f5da924c3a6"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ac41a29518e1e18a74a68199a12bf7588ff95fc32287bcd3c1cab90ca59906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b5731d5aa4969fd91a8bc74aee2f8eaf575a904ed22a6d6ab379ad7ff50d457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d173eb506408f249117adb658e7ac23b50fd049933474d2a472144bbd8839e27"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7870d0b8433b83425a676928fafc1b1d66512f67365b2a8f6ce351329be1fe"
    sha256 cellar: :any_skip_relocation, monterey:       "b277da929dcca474fa44027f775b0a4cec037d2be844329a2c3807f4b25bb6b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "216715141888fb68111e473514172ce0f4a32c9b3db5c971c8ed73c4b8060ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be6034bfabd74f897c36a63e77c41769f86e01566661d124abaa4593f409e3e"
  end

  depends_on "make" => :build # Needs Make 4.0+
  depends_on "pkg-config" => :build
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-vfs"
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake" # must be separate steps.
    system "gmake", "install"
  end

  test do
    stable.stage testpath
    ENV["BLINK_PREFIX"] = testpath
    goodhello = "third_party/cosmo/goodhello.elf"
    chmod "+x", goodhello
    system bin/"blink", "-m", goodhello
  end
end
