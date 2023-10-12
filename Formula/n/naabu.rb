class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "e78581ec64cd8bba3be7496c0b63d639ccd803f5aa9e5b7398e8d3cf86ba9a55"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b427bdf80edc1c45f44f84bb4a18476e3c0fd1680748834968b2c5bbc56bd823"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "338cb92c4952b0d34c75a7cf3d7d55ce832a68baf875d12e122d8ebd4b69ad41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197b2ae138e681e22f32e2d5d582d0e4b2eb613e4801e9875a57560eaa323d11"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dc176cc1d6ec4d103a1251c4f02185b4bf801e353be9bb22b06063c5b3317fb"
    sha256 cellar: :any_skip_relocation, ventura:        "409e73125bad304400a216936e9c2a46b62ad9d27feb0bd0ffd322d4503a1e12"
    sha256 cellar: :any_skip_relocation, monterey:       "8389707935106990799de28518ee79c8d92a393aa67a45b73a03257063914cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae8f9590a746d3356b6dc508c9d6355cd0e76983dd6abb79f8cb0c892b35e24a"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
