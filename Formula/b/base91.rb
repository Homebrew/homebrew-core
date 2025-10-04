class Base91 < Formula
  desc "Utility to encode and decode base91 files"
  homepage "https://base91.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/base91/basE91/0.6.0/base91-0.6.0.tar.gz"
  sha256 "02cfae7322c1f865ca6ce8f2e0bb8d38c8513e76aed67bf1c94eab1343c6c651"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3c288d4a7310b87b44e080c9b10ae3f541945cc7ba1e990edd1006df84c6ad9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c592a7056137ae37fd39f580b4f5b94abb84943d2c9910854ddf149d4099becf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47951f7f2de89d984b7bbfa58b5c39ec6d1fad793516cb925478e907882ffae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67a2d373e37965d8f4af56c50d704340f2a85efd2563a1801e8b61eeaa1d8755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1312d937857681b5c54a9d135b0e7b37b934fe8c3ef4be414222a876904dce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f97be9aed077e34c2aaf8aac0157fae476dedf2cf02eae3b23de8a74541e8135"
    sha256 cellar: :any_skip_relocation, sonoma:         "5631c841168b7506040aa82be29ac05c5a91714107e99cfa2d7f3b59fd1958cb"
    sha256 cellar: :any_skip_relocation, ventura:        "17bcc913dc97e5e52dbdd67aae0e622eea1593adbe692adc584c888c754577e7"
    sha256 cellar: :any_skip_relocation, monterey:       "2580639cbba0238bdf477650b1759dcb51d328fcdc9375ebbc031b355cb0ed23"
    sha256 cellar: :any_skip_relocation, big_sur:        "039bcf75c09fb75a7472e8f92ef349f2908073b4ac76c1c4573d1a393e248229"
    sha256 cellar: :any_skip_relocation, catalina:       "239a9f51f67e7b1de09d10c838dffd2c34ce0f6f58641269e2278d6478b36542"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "570aa4d67d764052049d02bb6f3843b306378950a45ac01145b0e11e183bebc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c611713705345338da5415ea274901781c883f71e870384f92866fb7275083b3"
  end

  def install
    system "make"
    bin.install "base91"
    bin.install_symlink "base91" => "b91dec"
    bin.install_symlink "base91" => "b91enc"
    man1.install "base91.1"
    man1.install_symlink "base91.1" => "b91dec.1"
    man1.install_symlink "base91.1" => "b91enc.1"
  end

  test do
    assert_equal ">OwJh>Io2Tv!lE", pipe_output("#{bin}/b91enc", "Hello world", 0)
    assert_equal "Hello world", pipe_output("#{bin}/b91dec", ">OwJh>Io2Tv!lE", 0)
  end
end
