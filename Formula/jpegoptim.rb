class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.3.tar.gz"
  sha256 "2600d1c84cee714b69d88944c0b90f93ef3eac7010c96dadabf32ea90d67e33e"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4e84a197e57cad5030cb1a0236729e42b8fb8812bff3af4750eea5a421f951b"
    sha256 cellar: :any,                 arm64_monterey: "0b84fa4d614118e5ad31c904b21b14d0e838ddb2b868dda33e23aa728f0dd3f5"
    sha256 cellar: :any,                 arm64_big_sur:  "2d053fd692342f8e0ffc3bf73cde05b414212b679e7f0c550dc16e72cc8259fa"
    sha256 cellar: :any,                 ventura:        "a7118ac5b89a31a18251fe3bb669449e18d143961068167efe26d39e52894157"
    sha256 cellar: :any,                 monterey:       "1bfcb4ad450508a3072766b65ad975b22fd37b20eb77888a044960d012900ed4"
    sha256 cellar: :any,                 big_sur:        "a548d4a4621dacb702f3af88bcaab382d899dd570c8e1428ece5f846b58f4a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2fa149032fa3622ad418e4f32510a6ebfa047758b20cf1ba49328b1a118418"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
