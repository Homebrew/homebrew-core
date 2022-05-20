class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.1.0.tar.gz"
  sha256 "a375ed5da0cd12993001db899de34990135491ec01f32b340c446e79c4a9d57f"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "253153935a0851deb6b71ab13af3aebe111135036bf9d0678f1d33aa2f6e3274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c530c40043a0c23148c855b81d173e6d35ac214ba8e9c053144243128dc840"
    sha256 cellar: :any_skip_relocation, monterey:       "51ebfce96fc385913a762cace6ba8c40547a1aabcfea5d7e34c01e2fe218dd12"
    sha256 cellar: :any_skip_relocation, big_sur:        "3477ce1b7d66726fda834b900ae1ccdb4b89a6dd0883cf1edd830c73217d93dd"
    sha256 cellar: :any_skip_relocation, catalina:       "392ba12ce5fbd2438bab43e06b680f253cb1c1bfd0d0df765f93442c410ace5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f54a5740f84e3be7c449a8a5e3465f859b784820764ce387214cac24c1ce1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
