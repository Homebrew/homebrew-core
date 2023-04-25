class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.3.0/bzip3-1.3.0.tar.gz"
  sha256 "29eb1d552b49aa04a13cb153bfb5b751f8e9e1bad7e80dcbd16359d87a7c531f"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a38ada616dd2f9d56a58c2a17c1bd239dfc43fc4177db0eabf7f93c4921a66a"
    sha256 cellar: :any,                 arm64_monterey: "f410bfeca6fd6f2fc67f47ac606054744526e721d0242994886b2e6ca041d853"
    sha256 cellar: :any,                 arm64_big_sur:  "218ebf805cb4bbb1061e28fcf8093c44f4dcb89f08b93c7b05cb8dd83e0ed122"
    sha256 cellar: :any,                 ventura:        "acac58e037205bfa0bbf67a49104c14471abafa3957fd2bae12ded508782e52b"
    sha256 cellar: :any,                 monterey:       "fdb8dd766b87ee91e9a47d383250f96930076e6f860d08cacd19a7acf2eea580"
    sha256 cellar: :any,                 big_sur:        "a6aa3a13d001b728b5a677dfcbe1afccd21e2c1ed50adf32cd28ba99e689a652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0f996e3ace8701a4e9a5855db89ccacc1acd7255395a7da658269efcf725aa"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
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
