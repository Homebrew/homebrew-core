class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "https://www.jabberwocky.com/software/paperkey/"
  url "https://www.jabberwocky.com/software/paperkey/paperkey-1.6.tar.gz"
  sha256 "a245fd13271a8d2afa03dde979af3a29eb3d4ebb1fbcad4a9b52cf67a27d05f7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?paperkey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fc50488f52f09cbf1b0fabc8ddefa543104654dff3a462d9d0dfdca67e89ffcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5f29efd5bd3c2ce18f744e141fbb9e3013a0474a3d391efcd1ccfdf31bc9c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b249d92841f7cada3fbbad6ebfa77672ba9ce1925f3e8d6b1169049e35d2c161"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3334f86e54a5038f18b31f703a22981ef66b028cda73e2bc985db6a0c74a401e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56628d74d3ba424c3c801ee83d03408a8fe0e72644b493504c1511d84eea422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c9db30e077414c7504d8b20e9f5809b2cde37997881c1715e51e953d90d76d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e0ff420725418bfaf5cb4f18985772bdf516087d88e2b37a7916f3a382fcf75"
    sha256 cellar: :any_skip_relocation, ventura:        "b052c9ccf5ad09a444113225cabbfe0d6a65a0d64fd5df1451d2660a9b7a5ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3f3bdec644389ce5de309eb2ce36e5829d9da8b611bb30bbb7a73c32efc669"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6af240418bfb7c29113a1861966302d2be55fc578298f6fb0a4f71bc8dbf89e"
    sha256 cellar: :any_skip_relocation, catalina:       "12be9f841cfb0d4069be3e461cd5e783ba4ea11195507a13763f90ccc026f31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "53cfe21caff97562617b491ee78d77e79761907e8e490d739334999ecd89fd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065de554c087ac3f19246e81fdbf2a60b64c2307f420b91029d781ec901b2d94"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-test_sec" do
      url "https://raw.githubusercontent.com/dmshaw/paperkey/46adad971458a798e203bf8ec65d6bc897494754/checks/papertest-rsa.sec"
      sha256 "0f39397227339171209760e0f27aa60ecf7eae31c32d0ec3a358434afd38eacd"
    end

    resource("homebrew-test_sec").stage do
      system bin/"paperkey", "--secret-key", "papertest-rsa.sec", "--output", "test"
      assert_path_exists Pathname.pwd/"test"
    end
  end
end
