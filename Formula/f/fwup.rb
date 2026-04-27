class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.15.1/fwup-1.15.1.tar.gz"
  sha256 "b42a8970e37dc9036cd3ad1e9e702793ab37b469082b4b2c6b8cb73b2ed44c68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32765b9fd836c7d873b898a28c467660a0dee504a6f48d5e67dfab918f5ca3da"
    sha256 cellar: :any,                 arm64_sequoia: "7d2a4765bc0ee84eab7629d2399f9233473ae51ea8462eebbcc5fb1a2be17a28"
    sha256 cellar: :any,                 arm64_sonoma:  "43c0a548bed1f8af284675c6c05552f2817a4fe2789484de32ec2403797c4fd0"
    sha256 cellar: :any,                 sonoma:        "5e243230d8363413c05c9f811528155163a62bbf58267d83838b487f287104b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40c65ed3a14a74d41a7f374d3c978ff2fae29146a47cba10f0f0ac1ff21731e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f907cc4b1a6668a216adeff2abbaf990189bb2be5dcc86ad2b8b71026ef401c"
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
