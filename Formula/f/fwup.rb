class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.12.0/fwup-1.12.0.tar.gz"
  sha256 "aed865e7067a3a54fea1d604457dbaff8b07f577737aeba6b23b240d2f9f562a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a6475fae09adbbd4d267481d3766d6e241524275285e614017a969da501cc09"
    sha256 cellar: :any,                 arm64_sonoma:  "a254ebf601c9189becda7a184f537a0aa4ac4a15b0f29434f4a7d77c03208075"
    sha256 cellar: :any,                 arm64_ventura: "d3e2a527a61fa63fb980dbf222a0f3b77e53a1a63d1b7e7c9e040f825918af5a"
    sha256 cellar: :any,                 sonoma:        "cb5000cb6745a5a7bd9de40cef64bf331190e500a2b9be212932e30a78c8cd45"
    sha256 cellar: :any,                 ventura:       "50c158ddc59870d967aa7a2964b37c57483427728c5d8d73ae2fa8f1e18a9354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e168989bccb02fee0ec1084e3518013687c07f4c839778f108d4783c6c4a61"
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
