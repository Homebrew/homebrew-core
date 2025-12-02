class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.14.0/fwup-1.14.0.tar.gz"
  sha256 "97068007fd4b2f38d09d26462b22cba82e757205b9bf77b4e264f53d9179b98b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65736754f5d8293eb780533477c12d52c09baa6020a94de1e2d779c4f7c0a79d"
    sha256 cellar: :any,                 arm64_sequoia: "10a68b9d8408587a9f2e0ff7e8dfcea0025f4ec0b02446c1816018d07e8f842d"
    sha256 cellar: :any,                 arm64_sonoma:  "9f4cc09588857b20cd9d56d3bcabed5e96a58c4efbc4cd4517be58ce913c9c36"
    sha256 cellar: :any,                 sonoma:        "b52e6827a30a259016ddecfd3f78f7f5e2d6d00dbfd9d4e15a2945ca55840ae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0385413cd6ae647a80b64339011651a3bda225fdc610fadd90d4ed036489f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb02b3415d3c1e2b9949d5ce2e305628091cbab93e44478ac38af7ecfea2b9f3"
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
