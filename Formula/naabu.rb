class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.0.tar.gz"
  sha256 "fdd90231ca0e502ccc09a57a2753ce79721703b9be12683be578b1947970a95b"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b0fbdc53dcdaf902fc0c9fdb3cdf6e7e53dc033425804235fa516b31746fd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04b3af2a0b8257f38f4fe83d0feaa26def8dc810d0a1d9d12fae2f4b8f179897"
    sha256 cellar: :any_skip_relocation, monterey:       "be5d49a5cbe9c9172bf06c55f236be6d6e4b9be2be9f251bc91b9900738ca57b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c27e308d04d45f935f8d9d432af08fb0083339596f706eba88e0ce60449ea88b"
    sha256 cellar: :any_skip_relocation, catalina:       "3e40b5a72a9d0c3905770a7ce120fc1681f6509a835a4f925352a61974673258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92863f7627d2f1dabd96f5e20cd7014e952291758688c86029274b3f4705ec62"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
