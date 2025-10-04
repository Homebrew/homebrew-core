class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "https://gitslave.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"
  license "LGPL-2.1-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "99050ee225d4cff6c68927afffda8d113f9d2cedb1d809ae06d4d22a5adbda6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "85f25f52b43ce52b80c082c154dba23fda5ab3c98e58fdd40699158fa971f3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6f454af3b08f47b018ca54327b09c82ddc2706217cfd5d7164f4b58f73d244f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d2048c8edb96fe0dd49b8cd52aa1139f63fb275523022cd2c4e7a6ab45a496a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6f454af3b08f47b018ca54327b09c82ddc2706217cfd5d7164f4b58f73d244f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ccd093a0733d354b484b5fb5245315c8507c512a0f96dc51d90d36c09779d34"
    sha256 cellar: :any_skip_relocation, monterey:       "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9975ca2bcb400d61bb8a456c951d9a069cff60f90efa440f211916fbc32bb5b0"
    sha256 cellar: :any_skip_relocation, catalina:       "dd32d79091815434db1c465b3f7caa6c6c346449558d82023a6d88ff92c6ba6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc837e2e6f74e31b6eff215a23896fed573675966f0ed4c325da058d86484dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0241293740ef38cd9f22206e021d3a7ef2be7cdb505320ca904b728c321ee80"
  end

  uses_from_macos "perl"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/gits --version")
    assert_match "gits version #{version}", output
  end
end
