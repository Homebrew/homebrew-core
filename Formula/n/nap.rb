class Nap < Formula
  desc "Code snippets in your terminal"
  homepage "https://github.com/maaslalani/nap"
  url "https://github.com/maaslalani/nap/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2954577d2bd99c1114989d31e994d7bef0f1c934795fc559b7c90f6370d9f98b"
  license "MIT"
  head "https://github.com/maaslalani/nap.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "13961de8d0dcd0c3ced9aa8ebd2ef3f9df61c4fa1bb67a7c1b1b368947f2277a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4f0de3f0692843a24c7130ca77e99d116432ae35d6c9282fe8fe578558c1fdc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "840fb8373a2c069dc80e54d6bf831597eb781c595bcdc6ad0c564ff9d4bb9a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e5ac9b5da7d19b91650509c620c45620a57230df2d487f6c43cdc2e6dcabe9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e5ac9b5da7d19b91650509c620c45620a57230df2d487f6c43cdc2e6dcabe9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0ed819808bb795ecfce79d5415ea928d48b3f4cd9d716ef26e0e48a4f88067b"
    sha256 cellar: :any_skip_relocation, sonoma:         "82eedff6a8561d4ffb1cc02b96c26ad249a3941ba49cd65963839b8fc87ad487"
    sha256 cellar: :any_skip_relocation, ventura:        "13824542ffb0caad2b26b347bb375fde1beedd26c8b3af84145917cb92dabe22"
    sha256 cellar: :any_skip_relocation, monterey:       "13824542ffb0caad2b26b347bb375fde1beedd26c8b3af84145917cb92dabe22"
    sha256 cellar: :any_skip_relocation, big_sur:        "13824542ffb0caad2b26b347bb375fde1beedd26c8b3af84145917cb92dabe22"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cdf8ed4b88c3ce3467132f96b2db5315853e4a01207c9edf25ca25f58c1286ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a201267139b6f4d72d65a5651b981efba2fd74d0583221b87071ec34ad1051"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "misc/Untitled Snippet.go", shell_output("#{bin}/nap list")
  end
end
