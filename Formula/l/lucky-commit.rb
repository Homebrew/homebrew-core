class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "1631a48a535517c603850ba8cc8f44bf8b11cde2c269d6fb1ae72fb07bf37349"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79dd8e23e5e34aafc38583104a02e4fba9a8f0600b05ad823ce6434c9cec4d12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee5bb3255c98f7752964997984ab36b9b135b5054f06b51b326b612b1a527305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a89e18b1ce6f2b07933aa6f175fae7692a70f17864a0cf778a0cbc8e48170680"
    sha256 cellar: :any_skip_relocation, sonoma:         "f56ffe7449f23459d455ae73e44b0d4574ff9ae724a4473b78419372b2a02ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "130a557e9dfb9e429b39d178f9ddada08b3dc46e98d163312f1e2cb0d6f98bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "f5db99e022a0a520dcf2ae78090633541dc5b7d2317f65c69870f3df07e37de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2001eb19052ec4411157c629934a56dd4a4e090d8343ad5a577ab0321a6c7c7e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
