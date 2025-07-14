class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.13.0/fwup-1.13.0.tar.gz"
  sha256 "70979d36b39857b37cc378291d3bca5a9e1feec0a1b66f67a79fae46d8831529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31c3bf9d91a3d49bcb75ae61e27fb7cccd856f69bae861841884430c0c99f1f9"
    sha256 cellar: :any,                 arm64_sonoma:  "6909ea5de2f883926be1af71e0f6316662f3b4aa26224e863791b9d6c137c3d5"
    sha256 cellar: :any,                 arm64_ventura: "ae6228df886d9372709f67031b05b0e52a02243de4ece1e0eea09d10be139652"
    sha256 cellar: :any,                 sonoma:        "968ceaceda1b320df56b862a25d4366b136151891c0025d8c5a3d2a9ebd893ba"
    sha256 cellar: :any,                 ventura:       "d07d9b1e611b39c49f7d7280b772fd98f4654cec4b15e1ee7c6dd7cf7ef0841f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8167e3a8701e07b6650ddf3ca485e03d7e508f054c009b714f6e551f3599c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763938b79feea5b422d84bf11c6f81b2471c3bb9e91734a8bb37314f6f9dd4e9"
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_path_exists testpath/"fwup-key.priv", "Failed to create fwup-key.priv!"
    assert_path_exists testpath/"fwup-key.pub", "Failed to create fwup-key.pub!"
  end
end
