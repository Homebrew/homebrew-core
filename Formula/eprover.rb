class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.5/E.tgz"
  sha256 "8a53dfb7276c10794c3ce98527cfcf977939769e7a5e6dc2eda9b38be3fc404a"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08f7333687ecf36046595b256388407ca819f0fc7d896389a3f231e0f1039df7"
    sha256 cellar: :any_skip_relocation, big_sur:       "52c89a856cb177db7e4b9a2e44420499c2899de522a646878e3bce984187f0ba"
    sha256 cellar: :any_skip_relocation, catalina:      "cc226a3377899294f072cab54a5a8247a78b1370817c56b8f2bbdfbd58428b4d"
    sha256 cellar: :any_skip_relocation, mojave:        "fc0066c171a5ffb6ecc6b25d0e439c7167e504e3afc2b4033c6c1a8b221db48e"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
