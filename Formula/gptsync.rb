class Gptsync < Formula
  desc "GPT and MBR partition tables synchronization tool"
  homepage "https://refit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/refit/rEFIt/0.14/refit-src-0.14.tar.gz"
  sha256 "c4b0803683c9f8a1de0b9f65d2b5a25a69100dcc608d58dca1611a8134cde081"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ad272478d34de44777be2688ad93d6bc82990ca97876a4ce7c4a9dee9be2fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fa1287dc7b267191451ad26d47a2a2c706ff784a0b12f007610aeb1fd4d81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce578e36d0f50ee223a8578434563aa237ee4c98d951d8c818c21571258193a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c711d1ffe374d2c6e67b5d36ea3f83e25102c2c1eadde19187fe571307b3048d"
    sha256 cellar: :any_skip_relocation, monterey:       "2edbbc4007c73171bd87e60f073b42b525b70611f42c2b9e61fb7a665414eb8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7bf7603d6040dbb5b1982641e3a8f7bf70a7c96c5a8c476b57a344609b9705"
    sha256 cellar: :any_skip_relocation, catalina:       "e6761d20c0090477f2914576cbb97654774a5de9cae4b3846187120961450ed0"
    sha256 cellar: :any_skip_relocation, mojave:         "76d760477b55a2ac3ebe3d2fb472e70ccd84a2fa8cb265bae829669e639897f3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8d21fa7f491b5cfe7a2c809a99d753ff4511c5354c4761751ab9c5abebd585c6"
    sha256 cellar: :any_skip_relocation, sierra:         "e822ef6c99aeaf6eee5812cd83ede2bc9a045dd556105150293bcf486898a59d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d355de7bea36e310d22ed1109a34574ab93859bfe9e44b9493ebe75cfe429c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf8612d628a08c143b24697ee37265edea17cfcfaa2bed8fa60be6a2e21356d"
  end

  def install
    cd "gptsync" do
      system "make", "-f", "Makefile.unix", "CC=#{ENV.cc}"
      sbin.install "gptsync", "showpart"
      man8.install "gptsync.8"
    end
  end
end
