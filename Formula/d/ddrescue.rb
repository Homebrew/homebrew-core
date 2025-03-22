class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.29.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.29.1.tar.lz"
  sha256 "ddd7d45df026807835a2ec6ab9c365df2ef19e8de1a50ffe6886cd391e04dd75"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e7cdf715cf98eab8958472f1f44422aa890de890bf9b8b4b617da619bcc047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85d7d4446452b151420ab5fbfdc1c9eb9a78fa84d8a4314f8ed84c5c43929b55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c800371fd465a91660b1c10912d7492ad3137f17c8f2eb4f93c3bf9284b1fe23"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd2c4a80a97627d8c3d03402786a3bba0a3006c05de07094ecc1274b726b961"
    sha256 cellar: :any_skip_relocation, ventura:       "20dc0c65999e389090bb3631b781bf7f36a17dae90fc3683ee46af451c790acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7269198a4c447bf31ce66cf0bdebdbe575e32431e681173b18f07c1d109e90a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a299a8590b6d15de46b13b906a5e96c86f4caa697b342fafec1e6786a3c4deb3"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", File::NULL
  end
end
