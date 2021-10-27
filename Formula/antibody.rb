class Antibody < Formula
  desc "Shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.1.1.tar.gz"
  sha256 "87bced5fba8cf5d587ea803d33dda72e8bcbd4e4c9991a9b40b2de4babbfc24f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecfbe9268b6f4468d331bcd1d2f1f3f888476eeef3f10fe7c506e51a93c65bf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "720cfb0bfae9001e929d57101e482b1206f5d2b6f0ca546681c8a5450113c74d"
    sha256 cellar: :any_skip_relocation, monterey:       "281479cf4916b767d99242f0fcc6fbe43cf3f96f5d4d7df6b424ab5ee86d3b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "68b409c42eeab15437a9c64a55e13f69c37f6e085bcff794bb1f9a8ca6419e98"
    sha256 cellar: :any_skip_relocation, catalina:       "572351da6247daf6bf29afbdcc8ff10c4fe47e9e413c2ae0df0dd249e855599d"
    sha256 cellar: :any_skip_relocation, mojave:         "c33467a9d42a9c767bd2d3382937e9f1dcf9bce2cb45fe3de6adb736ae2d6e89"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7af2bd8779f129597713ebd6155d493616f4ed4b2344cac9db84191b01f3110c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87285c55995d80af9cd4d1bd71a5879290bb67b2f08a7a492b4d94ddabb58455"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
