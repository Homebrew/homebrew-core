class Align < Formula
  desc "Text column alignment filter"
  homepage "https://kinzler.com/me/align/"
  url "https://kinzler.com/me/align/align-1.7.5.tgz"
  sha256 "cc692fb9dee0cc288757e708fc1a3b6b56ca1210ca181053a371cb11746969dd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?align[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8181265610c0cb43adfc0bdcf0ca4ba3ee28debd69c6e7c08d2459b1c21f4cbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "984c0d271dd402ede064d9e584f82533fc9f0a8f5f7ca9339d952fbdd7d1f3d6"
    sha256 cellar: :any_skip_relocation, catalina:      "cca0be9634d92fe10b845b98f26ee953f59482e0436806484a907f487e76d093"
    sha256 cellar: :any_skip_relocation, mojave:        "b8de67536085ba47ddeaed3b8567645beaf5e84ab0b7ab958cf7b6cc358e10dc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4b0b70a5909b7d6d2fa78fcb4e36acb20295202adbdbd6bf5754530f7e055199"
    sha256 cellar: :any_skip_relocation, sierra:        "4d07f4f2ae948de293afdc80a5a736cf81da7c335cec1778f5b7304debda6599"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c2c177c8be3b5a58e60f3a1f39d9fdd3cc3d39247d92be45142cd06ae80273bf"
    sha256 cellar: :any_skip_relocation, yosemite:      "caa9e8c3b3a9d946b95d5222b1518c5307499d57fe17f593ec3911f9cc6eace7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1c578b01c461e06422ac5c75cd86044992f11ab65552b43b637e647e954baf"
    sha256 cellar: :any_skip_relocation, all:           "c9faae10da1b1c4bcec6d0c36e63b5dc9320c1bf7751c771b11da859a56a1146"
  end

  conflicts_with "speech-tools", because: "both install `align` binaries"

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
