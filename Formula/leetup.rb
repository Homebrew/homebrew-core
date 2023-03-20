class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/v1.1.0.tar.gz"
  sha256 "33e4be4278c72d09a8f20615aa4dbf272ea3087750c3ba31bdaadada4cf57bc1"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a9023a6049c718d5dee32895523ef4b0bbbbee4c8e7813866bc8b612d9c427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "107829578091e8b06dec794713b0754517d470849430501f85b2bac9eb551ef6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7574be5dfd85a7ea0683ae5bd375e77b5719e11937ee5b08b960b59097a2f919"
    sha256 cellar: :any_skip_relocation, ventura:        "1a94fbca1569c4195b1441183cfdf30f627dd81e3ac8da99beeec1e84e1320f2"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3d406b4709ddb79c546ea28a08ccf9151554137bfd2ca60d0d7d7249c891a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "79e784c0455508d672184a13892c029ee6db1f284180b7694eb0cea13f2e7fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3020c24a7fa83d25381b06aa6537e9f4c3b39405517a3b0f0f5c8b990a2d272f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Easy", shell_output("#{bin}/leetup list 'Two Sum'")
  end
end
