class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d844aa7168534cf328dc553cd9fbfe58bd19dee920f630240ff1545d7c20b4e9"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef6e3f92084442eecbb9ea40f7ee918bfe72e1dc10a8290736a159133b86682f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e9398506f9ea09a2ca5d46f4312040a237f88479d7a03d0a557e074073e2c54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbec234f79db7f8e913a30314bb67bab5f58374a9111e18885a1b87d9b842803"
    sha256 cellar: :any_skip_relocation, ventura:        "70ceb1e2bbd14ac9728263c75ac83a5e7645cebccf50f9800d389621338318ae"
    sha256 cellar: :any_skip_relocation, monterey:       "1e484e8919f2ca8bb4e384931442400f02a282b00a4a6168bf5be855eac92515"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce01397e3ff4d5629438d771c89d9686808f08ae08d37af11886099756f38fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0665aa0dad78972ef0514e45dd98128846cad22cf96b6d15429ff42658e84cd1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
