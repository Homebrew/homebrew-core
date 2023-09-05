class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.6.tar.gz"
  sha256 "dbb886eacb465ea893465beb7b5ed8340ae77c25b24098ab36abcb69976ef748"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e2deec1fde2416c71c2791e9831aa2b3cf3423bb6c63f600b1276b9c6954db71"
    sha256 cellar: :any,                 arm64_monterey: "5525c4c775e115f9921620fbc6887a1660a70683d3d7cde9791e1e689f65b7c7"
    sha256 cellar: :any,                 arm64_big_sur:  "9f7ec039cd4a2f3374ad095eb4ee37d951beea4480c586a2b8f3ecdcff31e235"
    sha256 cellar: :any,                 ventura:        "9179a403cca09e0701923f329d26b526e240e89ac487615f0adfcd41721fce41"
    sha256 cellar: :any,                 monterey:       "7184b921c76cbb2c0e2d0984e30273627bd4f55a970de06c39f3bdd56d617a1d"
    sha256 cellar: :any,                 big_sur:        "98c2de88e32527214e0c16874553043b9ad7d31e2d83f14f4700ff96f271fd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21757bb4952cf37ac4ae45ae62dcefc5ca22d9cd04474a6d51f9b67dbca1a392"
  end

  depends_on "liblo"

  uses_from_macos "python" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
