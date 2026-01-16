class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "https://catseye.tc/article/Languages.md#befunge-93"
  url "https://catseye.tc/distfiles/befunge-93-2.25.zip"
  version "2.25"
  sha256 "93a11fbc98d559f2bf9d862b9ffd2932cbe7193236036169812eb8e72fd69b19"
  license "BSD-3-Clause"
  head "https://github.com/catseye/Befunge-93.git", branch: "master"

  livecheck do
    url "https://catseye.tc/distribution/Befunge-93_distribution"
    regex(/href=.*?befunge-93[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e7cb6bafad0910e0180d079e0915876d138ad0ab1a7d5bdb7051d41ad1c5a9e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7cb92a7855edef8e243b3279f39eab303d89733524b215aeef9def5bb4273a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "def7c8d4722db8b8db0213eaee2bb178e072d0d1a5ceaf9a22e0677304d2f6f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2599a525caf498002cb5680508784d8e650abce0d06eaba12ecbb162231791b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c40ed79d166ad25eec0fb9b75850d445d1cb2b6e9252e3fe40b0fc7d79b8fdb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05324749e9d37d4bdf4b6737ddcc2f48489755c60a38752f4cf8dc51e1b93085"
    sha256 cellar: :any_skip_relocation, sonoma:         "5486169859b1d8ed1522380e54f750cbc619ce7b06cfcbf91cd84a473f0adf3c"
    sha256 cellar: :any_skip_relocation, ventura:        "db58586d50b2268a3889d49899aaa3db014546dd905176b33e34785483be516c"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec6a5c6ef76cf0bce2358f3ae72ac2336bba0c7f2b31419438c82bdc3ed6133"
    sha256 cellar: :any_skip_relocation, big_sur:        "bba6c29ce6655061c2f0323b1ee778c275e0bc18f850158274a03af1ea666fc6"
    sha256 cellar: :any_skip_relocation, catalina:       "190fa82b0fef31f096a102f3b33205112cb206f578813f7ac78f78617c7d73d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81943fb8dff560b6d4a8641bd26eea7433127d01044710a3c46fce634cc8ce4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f71eb1910501903b8af94c21352759032696046be49995beb95caead85a8398"
  end

  def install
    system "make"
    bin.install Dir["bin/bef*"]
  end

  test do
    (testpath/"test.bf").write '"dlroW olleH" ,,,,,,,,,,, @'
    assert_match "Hello World", shell_output("#{bin}/bef test.bf")
  end
end
