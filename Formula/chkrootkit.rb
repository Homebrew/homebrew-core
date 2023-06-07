class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "https://www.chkrootkit.org/"
  url "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-0.57.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.57.tar.gz"
  sha256 "06d1faee151aa3e3c0f91ac807ca92e60b75ed1c18268ccef2c45117156d253c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fada858d477924038a03199cbac79cd7afc04fbb31b42b9aecac628b39cd51d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b86a8b17ffd5a0265a6125aaa91074ac28498afdbdc38cbe78a200bae2e99dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "197c2bb6a5f4743cea04329b0da6ed3335cb85583c5378f9660ae4d6efdb092c"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb4b52d54410d6c35faff05d0aa539165c658f96a3ce4350636a45e415a45c9"
    sha256 cellar: :any_skip_relocation, monterey:       "3e29dda433d905bba6d48e19c80ec8e7576a6920f31cf598859a52445973f7e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3084546c6acaf0bb69c35fef3d6489876e1ff3d277181dea8822aac0c6cc051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4252ccf9c41f02c23e5387848b799dd0089d47365ab1b9ad55bf6fa66bce6747"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
