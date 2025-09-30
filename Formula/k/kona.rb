class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/refs/tags/Win64-20211225.tar.gz"
  sha256 "cd5dcc03394af275f0416b3cb2914574bf51ec60d1c857020fbd34b5427c5faf"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:Win(?:64)?[._-])?v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ffed758f35647079748b660475d1ae5aaa0b0b1804fa2506bad4ee473314f805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "84c61f1623af99fce59ff37ac3310eeb4c20bfa9ed42b78eec9dcacb8c9d57c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3173ebdcc5b42b89e00caa74715d04512069ef0fd7d124f0c9b8fb92fd2a54a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b0943e3d66400117a41dd547e627750c8c98ae95a1430831343995151cf3349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1a6b849baa2c0423981e8a528551d49ce8a18f0772a6381038e0b3f27adb9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97493e1f57dc878702ebf3a34af7621a5f655104d684e7c50ef316c8cb30f97d"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb1310b9df64a4a40b537f6e473c757109cc29cb2647771af3246afff8bab55b"
    sha256 cellar: :any_skip_relocation, ventura:        "90ed66c0f504012d6b9842882fde439a4be1c63c7d460aa9e046ffedba2b578a"
    sha256 cellar: :any_skip_relocation, monterey:       "73330e436e416c19f9a4abdd920173c99725bc5e8ca4b18ef3ebf1df20a561c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc727b02b917dc2a6b81d8ad679618ed7128320bbb177cbba4967ff75d35a810"
    sha256 cellar: :any_skip_relocation, catalina:       "39a59be89532f96362eeeef2d5be14770da588944666ce3a178926f04b0f6e1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d6b3318bcb3e9c9129958230cc0884fdf263255e07f96d1a62acdb872c0d28d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0418f26e5be870a8be5747b920ae20db61707f110c3e63c992ab397b8b87dc"
  end

  def install
    system "make"
    bin.install "k"
  end

  test do
    assert_match "Hello, world!", pipe_output("#{bin}/k", '`0: "Hello, world!"')
  end
end
