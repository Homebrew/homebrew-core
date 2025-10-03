class Kqwait < Formula
  desc "Wait for events on files or directories on macOS"
  homepage "https://github.com/sschober/kqwait"
  url "https://github.com/sschober/kqwait/archive/refs/tags/kqwait-v1.0.3.tar.gz"
  sha256 "878560936d473f203c0ccb3d42eadccfb50cff15e6f15a59061e73704474c531"
  license "BSD-2-Clause"
  head "https://github.com/sschober/kqwait.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a8037aef7b7c8539a012c549077b2653aeebeb3b6fa7860263bfe677625b5380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "69088af879a12bce91e41c0f70c063c27778c4668db657edd7b99062e14f9c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61eda480313a8450e8629464371f24d6ab7f223fc8eb56290666164e572a6792"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3747581e5e96f01908dc6bc5b5368e1f40e714821c69ea8884ced4cace9b0fc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647d43de225f13a8d44c1b496bea51d180645b5c51cee5de9c82484117549d7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfd6026d7a40557bb6e2e660af989426984359a1a18af842237b46a7b8af10b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "30bea99e246e8c62407490ef3ccf3ce5ce5df3cbb39a8672a6654f14f7bbc025"
    sha256 cellar: :any_skip_relocation, ventura:        "46fdfbeb3a8961f18b4da5e0d1b94ae232b45ea789a701d963317a496c5542a8"
    sha256 cellar: :any_skip_relocation, monterey:       "f348cb75f4cc2ebc25a690de447dee670a144707256a08a252454d27fe52a042"
    sha256 cellar: :any_skip_relocation, big_sur:        "d628f1544a08964c38352d12b7d7c8eab0317391e7eceab195d11882852b4ee3"
    sha256 cellar: :any_skip_relocation, catalina:       "a126094dabbb2fd9a2c539b1515657c1855bb0c971492ca0d6c56aa97bfebe48"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system bin/"kqwait", "-v"
  end
end
