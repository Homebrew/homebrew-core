class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.5.3/bzip3-1.5.3.tar.gz"
  sha256 "c48823353084df2a5a0dba44fd5295abd078e40b49f09700d08af4d9b1e31d67"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81921e9c4facfdfe8650998141d3a5f3269003d0bad236ec57f90707ea3a73e8"
    sha256 cellar: :any,                 arm64_sequoia: "e15d757bd8cc8bf4184b63572e4e9e4aa2098fe23b9ec7f2cd0fd5698f0f9198"
    sha256 cellar: :any,                 arm64_sonoma:  "6e0f80b2d8873b8ccd668c4086ab8526898cf96021e58c89872f67649d23edcb"
    sha256 cellar: :any,                 arm64_ventura: "1bb455120d20c0c2635e1d12e5b2fb542c63324debf078a8b50b1f535c661fcf"
    sha256 cellar: :any,                 sonoma:        "046095415fe0bd81f8234e3a9bcd5904b405c5e125b8d492f7d77c5d29a9381e"
    sha256 cellar: :any,                 ventura:       "4f16fb9cc53ec9127302c9a03838fccbed6189f987bad93ec6a8a855fbcbc76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "205609d980a9f5e65292fcceb69322379ccb3a7c58cf32d26669e5fb2c43cd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234e3a3449f0710e43724ff50fae9e819ed354869954bd989f005951a7ac386a"
  end

  def install
    system "./configure", "--disable-silent-rules", "--disable-arch-native", *std_configure_args
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
