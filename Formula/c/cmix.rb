class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/refs/tags/v20.tar.gz"
  sha256 "a95b0d7430d61b558731e7627f41e170cb7802d1a8a862f38628f8d921dc61b2"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "087b737dfd467bda8b0ce62227d8bf0946754ee55507130a0cd84ddbdf3b42c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8eebb90a33656eaff7664633fa0422d594d6c5e3fd2c8270e9831516844b610a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e9ba39f214720c1b65d25eb08fd16b0a84cfc424143817bb8fcbb33a863cea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe893125d8092e5bdabbb902ff589d2368a012c863cfe71def0d98652ad6fb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301859a5c0ae275d3e4bd543662fa0e8ec55c80f386c95acc82aca75bf3adf1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "161b8e7138face7fa88bb94541da7444183ea3b02c819e8a406120349cc3d12b"
    sha256 cellar: :any_skip_relocation, ventura:        "257458d58bd2f6e17013d22904190dde42b96f5c6e28dff73b5874832db82439"
    sha256 cellar: :any_skip_relocation, monterey:       "a9241607506b03b1e9c0a77a09be19a3ae069f8e98d2507de654410774839a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "87e851c4cc26bcfe1fab20b165cd369351d5cfd27586dec415e373bf1c1d1674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0092c27accca6642f12d8c0d79423e5722dd17cbd20a93c194f231999d0e8655"
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"cmix", "-c", "foo", "foo.cmix"
    system bin/"cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
