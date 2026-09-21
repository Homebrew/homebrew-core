class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.17.1/fwup-1.17.1.tar.gz"
  sha256 "7672c6568b7538ed81b8557c91bf3a198599dc9eb6f69ea4441cee8b1e87c098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c2bd8bf0f168fcd3cbd4b0f7c2b589a1f6c4f83243384afe7d6c8b3f1e3b007"
    sha256 cellar: :any, arm64_tahoe:       "da8b276e1925688560961747faf96c8fad7e00c44049a3d3c9bd2349cef511a2"
    sha256 cellar: :any, arm64_sequoia:     "191c88ec1390c8f6a844b9568b31ca06a1d93eca1ac54daee81d424be70c6b72"
    sha256 cellar: :any, arm64_linux:       "6c993490673261dc6f71a6c8817b763af67b264b7056fb276d9f4b3b847bf7cf"
    sha256 cellar: :any, x86_64_linux:      "e36da541298bd05b0675eed95a0cfcae004d9e69da608c87ca945f15b219bef4"
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
