class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://github.com/flexpaper/pdf2json"
  url "https://github.com/flexpaper/pdf2json/archive/refs/tags/0.71.tar.gz"
  sha256 "54878473a2afb568caf2da11d6804cabe0abe505da77584a3f8f52bcd37d9c55"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "058498536ab559f677a0d83f45179b9958c5c2274378cea76f63fc8e613a1076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6af0ae7d69db0ff147f44d9f987843ded25580c0d2c5d00b3909f18c4566bdb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a791ed61467ee9df00b0901fed7ffb14f97295d2139f01363bf433c879e7be94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323095faeba1b4fd27ec6040ef7a5037a1ecbbc7f077cbde173a72c5ab6c3396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c113b37537d9cdd7e698502406a17d699eb823437a6d9086c68591146c074a54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e648062e7a117f95679cd30c63773085ba2712752450f0b422be8f2fd4d66050"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be2124143b035485aaaeae155324606f06f6400971a67b20c0bd82051770e55"
    sha256 cellar: :any_skip_relocation, ventura:        "a06ac07d12709d87065c455126794ee1f5f282c895ec03e90abcd498b0c83739"
    sha256 cellar: :any_skip_relocation, monterey:       "8af9890390ac354624c50a6cbd706d6b538ed8050bc54b1b4a5d091a249401eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "20fe898333fa761b942ee5b0f2d41e47660389a250f5c8604ff1ed22788d9581"
    sha256 cellar: :any_skip_relocation, catalina:       "035c69de85f1cad569ff743faef796a88b9f9a706be802bf111a83505858b366"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "917e8246e56311c899f8031c17eee02347d143e023b7e7f26a18a924b983a916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf26e386ef0d0916e59bb3aea14ccbaf5e08e87fbc043692d7a445ff481f9d7"
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert_path_exists testpath/"test.json"
  end
end
