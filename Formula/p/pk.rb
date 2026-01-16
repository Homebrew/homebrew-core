class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz"
  sha256 "0431fe8fcbdfb3ac8ccfdef3d098d6397556f8905b7dec21bc15942a8fc5f110"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1ef1dd86ba0dbedafb386987968dbdf0f22472cb290a7742e80e55efd6976b00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be0b36f6d80ee6d6191207faa7454eff5a35fac1aaa54cb3df986482bb4129fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df016243a24085cb085bd78cb4e2a0c0a58f0f017a94a09f5b9f7555e6739745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca0e954622b756edff41bb508288566a7a950c3a30e83ba0d8013289599afa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123a225b6c4a6208cb0b6847bae1cf60ce8934dccbfb1c5c9eb7ed5d055f6c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "410e868c6d09c373aba677fe256bea9dd1e3a09d867c009e0afba66c6c671c8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "827832f8c2cedee3e1c6f4e954a8d601a6da16bdbc6d629f96aa1434a5a0286b"
    sha256 cellar: :any_skip_relocation, ventura:        "abd231d946e68bfa108184889fd1685c060908ffdfe2c09c203918f340160181"
    sha256 cellar: :any_skip_relocation, monterey:       "21e1d9edcb574d9c010e7bbb08bb4430eeccac5e89f85029a6e247a586117c1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e03d0ccea4bda2a3616ba39950d8c685e0a49775ed61abfd4b25649e4d2a25"
    sha256 cellar: :any_skip_relocation, catalina:       "2f9c36e03681f154a24e063e2600d0de8f8afd5f9b114083ef1f34656a7721e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6c8968e6c98f33f8dc985fa43ad59ced699019c620095f1f7569f73bba19d654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebcfa3e63674f0aed1d0e541cfa74edd1efcdb1e1a4a4919ef993c14b4b9b6b"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
