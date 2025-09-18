class Gptsync < Formula
  desc "GPT and MBR partition tables synchronization tool"
  homepage "https://refit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/refit/rEFIt/0.14/refit-src-0.14.tar.gz"
  sha256 "c4b0803683c9f8a1de0b9f65d2b5a25a69100dcc608d58dca1611a8134cde081"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bbe45718163e20c2768294dc78efc0193617838f559bcd5b1a5dda8cbec58beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ea49cd4b6cbba08342f764f78e56496a594edc524a8dd6ee3e0a475d6b558710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b27f3cc32dfca25b1c1cbe4ca3518420cd1eb33cf867ec3d7d3941c536b4ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ad272478d34de44777be2688ad93d6bc82990ca97876a4ce7c4a9dee9be2fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fa1287dc7b267191451ad26d47a2a2c706ff784a0b12f007610aeb1fd4d81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce578e36d0f50ee223a8578434563aa237ee4c98d951d8c818c21571258193a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "20361142889d629384cb80a6f2c00ad663351cf5b39fcc4aa1bca450d17950f2"
    sha256 cellar: :any_skip_relocation, ventura:        "c711d1ffe374d2c6e67b5d36ea3f83e25102c2c1eadde19187fe571307b3048d"
    sha256 cellar: :any_skip_relocation, monterey:       "2edbbc4007c73171bd87e60f073b42b525b70611f42c2b9e61fb7a665414eb8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7bf7603d6040dbb5b1982641e3a8f7bf70a7c96c5a8c476b57a344609b9705"
    sha256 cellar: :any_skip_relocation, catalina:       "e6761d20c0090477f2914576cbb97654774a5de9cae4b3846187120961450ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7ba72e662e2aa7db8b0a35fe335c685095cc48a1b04a8270fcde4cd8348d2e29"
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
