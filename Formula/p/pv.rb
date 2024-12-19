class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.24.tar.gz"
  sha256 "1066ad83737cd2eb872b23c6a3c32f24c1af92c73deacb70cfb302001974a18a"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b399be5422bcd9841f428a2cdf20978cbe106f894df8aad117db0522546ffc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c993bbef82690b6f4e773421ed6a63dbd069b1da408b0be444839e3048217384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f558107fcfd4617aecd28b65b6fb8bd11b2cd84eb10e18ac87eb441f0b0147d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "51198750d333a2fae32d0cba5a0a5a2c8d16b1c777381c9d7554deff74adc3a4"
    sha256 cellar: :any_skip_relocation, ventura:       "3d34a1ac295d5a2d8bf661e71cda8128992535f9d11afddb6888d0b810ace337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca5db0944e81a9008d9a49413c1b48fe38354d3b1be71d7a9d3e409fa831859b"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
