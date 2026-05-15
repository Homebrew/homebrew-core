class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.16.0/fwup-1.16.0.tar.gz"
  sha256 "a07b79268247ecee134a916ab928914be2a4ecbac0bc5e5f19212ec36ecb5c21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6889435df5cb6061040ca6b6378fed61db3cbd2e788612bf2a1b0378bf52ae36"
    sha256 cellar: :any,                 arm64_sequoia: "bf97603e599df41655e6815fe756278347f90c143d8e3c1be7e274cd437b9d06"
    sha256 cellar: :any,                 arm64_sonoma:  "3b8fa9c33117cce4004f7ced5613b5dd7fac92d441e1bb1e628f73e698fd2943"
    sha256 cellar: :any,                 sonoma:        "f0f7bb2c63e78f15bc9de214c18b7d1f6adb62c5975c156fbc79e9e350c14b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbdf90c835d9d352a73c6144fa8b13f2c2956e60376faac2bbbf13f8d52230fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c560ce6ce9cb60effd7b9da4807b0ef394747de3314ab3b514d4c5dc216b76"
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
