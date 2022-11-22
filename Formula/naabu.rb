class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.1.tar.gz"
  sha256 "004286db0d37fdd58d86ca83968a77d5c2416f31c0f0396695768c715c86cbec"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a5839e15964012e88b5ced1dd6f0f6008aa6313c84bd82354f55c36d37baff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f108b45c843ada70d1f4cf8164dc325a34796fd575cec79ed9291d134d61e86b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3953049728892f47e00b2f8b76430fb0ccecf047290140fe905ae23f559d1fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "33a16df0ef7c1ee2ef122332e7d94c485ce13bacdaa6b243c439dca101884fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "26611d616775ac13dbaaf6ea655fba3f7173a63256a52f51c024c19947fcc421"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6dd55503445319d5d622be6f5e9cab8b905cef329dd38569550de6f1e8853fb"
    sha256 cellar: :any_skip_relocation, catalina:       "1d0258feda4f017ab101ab36150c53e9f4cc67c2c8a915ff1972ad99db256dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8baea318cbaeb4d0a734c2e96d5717727e958cf11bd9c8c3a1eb900ab84e173"
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
