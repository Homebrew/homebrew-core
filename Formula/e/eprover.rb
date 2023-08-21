class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.6/E.tgz"
  sha256 "aa1f3deaa229151e60d607560301a46cd24b06a51009e0a9ba86071e40d73edd"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "933c3244099f0d7631bc4b5fff2ff790686d3fd8519448118d80a57664133984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2df4ffe6c58bfdbd59c96e662f1ca66a91f5f26b21b8de2cbf6e36368443f4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5b3ef3fe7c4d8a83d6bc36414cc31a75ee9ec0444e8bc3a53ad9c0e398d388"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5c8ccf21c2651c3e5ce3ee03cd4b02bfd17e2f6d4a4cd7d84f27a0eb86fa8b"
    sha256 cellar: :any_skip_relocation, monterey:       "d43e11494bbb94729f103b7680e258d98397954b26ec1ee876c7600f6433ea37"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca253b65f824844b7238c6a48870d62aa7c59759b30caaaf297019dddb1546f"
    sha256 cellar: :any_skip_relocation, catalina:       "fdad068ad22a703c18f58502d91a24fa16ba2fce017b0f39b9145583930b19c2"
    sha256 cellar: :any_skip_relocation, mojave:         "2d9b6284695c33af156b99e32026eb934a889ffa0d8891cb1f7f49a8a1b72942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5038a0c14455835be07e268a78233512aed9ecc0cfcb22bb0041c533d58cdbe"
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
