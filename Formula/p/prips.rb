class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.2.2.tar.xz"
  sha256 "f9d710ba19ea0d9f68b633b7093092c84f519313ca28ec0632b37c4e5a85a0b2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://devel.ringlet.net/sysutils/prips/download/"
    regex(/href=.*?prips[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ebfff5e1dc46e910a96a6c503115aa7b8774cdb74593bfa0b06fe3aa3ecb12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "119d431a378f96585d6d92857c3dbf524cca2bad9e993d81763015f2e876ebf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4824dd5010e37dd1c8dd3689fd00b7a7bc861aa229ce86bb67d14e814832f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "154be43d4c20994c4d9dccf42241280a8303ec678d8bc7cd75d8c13eec590809"
    sha256 cellar: :any_skip_relocation, sonoma:        "128083e5ded105075f9158cf78e8b516aaf6cc909b09bd1e9212d7f2df30f1bc"
    sha256 cellar: :any_skip_relocation, ventura:       "9503baebbb4bb27ba78205df85c92b120830707544988328f25fc97983cdf2f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a1ce4c011174062fa45e6cad1c9535e7cf321e2eb1d5f2a6b40d9f9a322fd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e565bae503a491ee0e2ecc37889989bfab8cfe96571877a3163cbf28544d61"
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
