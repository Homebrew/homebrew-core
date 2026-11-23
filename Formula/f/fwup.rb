class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.17.2/fwup-1.17.2.tar.gz"
  sha256 "6363e2b613593c1c678c2de9d4b0e48014351059a602480c8119b6af02312fc6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "df69335a4259712b8cf8a55b03373641e4c85203df7e36713ea1c715ceb99725"
    sha256 cellar: :any, arm64_golden_gate: "89d0d0c85f872a08ac118985cc46021aa60f74d942714ef32bc2e08a800cae54"
    sha256 cellar: :any, arm64_tahoe:       "9a372f347134c2acb63f0414c83c2f0b5e4b7e2a4adf1959bd9d2f6341faab9c"
    sha256 cellar: :any, arm64_sequoia:     "f5486fa3790b2faf71f840114fdc5d46e26457032b095285b4571d2d4f4bfc06"
    sha256 cellar: :any, arm64_linux:       "d9e7839f40aaac0921d15e7dbdfc1ca1385fe52c2d89e8a7a7695fd10c9075c6"
    sha256 cellar: :any, x86_64_linux:      "e6b1ad4c6082a461c17f1f7f7e27313255548e760a30243f6eb8d20fdc6dd53b"
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"
  depends_on "libarchive"

  deny_network_access!

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
