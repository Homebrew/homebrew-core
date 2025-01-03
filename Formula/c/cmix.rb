class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/refs/tags/v21.tar.gz"
  sha256 "c0ff50f24604121bd7ccb843045c0946db1077cfb9ded10fe4c181883e6dbb42"
  license "GPL-3.0-or-later"
  head "https://github.com/byronknoll/cmix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8eebb90a33656eaff7664633fa0422d594d6c5e3fd2c8270e9831516844b610a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e9ba39f214720c1b65d25eb08fd16b0a84cfc424143817bb8fcbb33a863cea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe893125d8092e5bdabbb902ff589d2368a012c863cfe71def0d98652ad6fb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301859a5c0ae275d3e4bd543662fa0e8ec55c80f386c95acc82aca75bf3adf1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "161b8e7138face7fa88bb94541da7444183ea3b02c819e8a406120349cc3d12b"
    sha256 cellar: :any_skip_relocation, ventura:        "257458d58bd2f6e17013d22904190dde42b96f5c6e28dff73b5874832db82439"
    sha256 cellar: :any_skip_relocation, monterey:       "a9241607506b03b1e9c0a77a09be19a3ae069f8e98d2507de654410774839a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0092c27accca6642f12d8c0d79423e5722dd17cbd20a93c194f231999d0e8655"
  end

  # patch makefile, upstream pr ref, https://github.com/byronknoll/cmix/pull/69
  patch do
    url "https://github.com/byronknoll/cmix/commit/702022a974cbf7906bcbaed898f1de95d3cbb32d.patch?full_index=1"
    sha256 "62143fadb5dda1024b0d51c1bb86263eb15d842193e02550a65924b3ac86c28a"
  end

  def install
    system "make", "CXX=#{ENV.cxx}"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"cmix", "-c", "foo", "foo.cmix"
    system bin/"cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
