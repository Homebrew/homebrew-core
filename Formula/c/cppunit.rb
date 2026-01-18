class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.15.1.tar.gz"
  sha256 "89c5c6665337f56fd2db36bc3805a5619709d51fb136e51937072f63fcc717a7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?cppunit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "106d4a437b3dae596bfb93cc8e04de0e28d97d3446a5ad900f926168c8773f45"
    sha256 cellar: :any,                 arm64_sequoia:  "081175312ba1bb288369cb84ff8a8e3bf11cf9c451b80dac6cedc211590d020a"
    sha256 cellar: :any,                 arm64_sonoma:   "192272d9c0a8a984f6efd69def9b47c5f3eda974f27daebb448362501b8e81d2"
    sha256 cellar: :any,                 arm64_ventura:  "45a8c4e8ca0defb8adee6028c2d213c7868bac9fdc9a4e814ad1b45aea1c3c14"
    sha256 cellar: :any,                 arm64_monterey: "7acd81de05bc607287b7133050c269e2ea86ac4e1141cb71ae85af4cd62e7f50"
    sha256 cellar: :any,                 arm64_big_sur:  "42291951a34e6fae578a9c25d2a5c399dc1e13ec3f700c017f96d7576acabbf1"
    sha256 cellar: :any,                 sonoma:         "7f1cbdf09781f2a7ad3ab585deed44b6e230815e50c2fa2a533513f11c4272a8"
    sha256 cellar: :any,                 ventura:        "7e5529650f22b5b4e19ff31a2af7134a11a112b8cbdbbd383cb50b0257e6fe7b"
    sha256 cellar: :any,                 monterey:       "a373aa7f91fd426cccdf9c8775439b21e620f529488030af40f5bd8ea79013e1"
    sha256 cellar: :any,                 big_sur:        "8890cb5c9b85681b735c3756d301df29beb98e2c0d0b10f2fad073e6f1870101"
    sha256 cellar: :any,                 catalina:       "3e194b84577c733e5641f305a1cb5cc76355f13037898afc56c3096f98bb78fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d0a96b2919d44c81f063814b1e9272618b0144729a1c09f4f2878c63cbc7ee97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1024a59b0bca4572448d7ed2e1152688d1b9be616d3b0644c15de8cd982c32a5"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
