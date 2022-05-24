class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/Win64-20211225.tar.gz"
  sha256 "cd5dcc03394af275f0416b3cb2914574bf51ec60d1c857020fbd34b5427c5faf"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Win(?:64)?[._-])?v?(\d+(?:\.\d+)*)[^"' >]*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1a6b849baa2c0423981e8a528551d49ce8a18f0772a6381038e0b3f27adb9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97493e1f57dc878702ebf3a34af7621a5f655104d684e7c50ef316c8cb30f97d"
    sha256 cellar: :any_skip_relocation, monterey:       "73330e436e416c19f9a4abdd920173c99725bc5e8ca4b18ef3ebf1df20a561c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc727b02b917dc2a6b81d8ad679618ed7128320bbb177cbba4967ff75d35a810"
    sha256 cellar: :any_skip_relocation, catalina:       "39a59be89532f96362eeeef2d5be14770da588944666ce3a178926f04b0f6e1c"
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
