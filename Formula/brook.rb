class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220404.tar.gz"
  sha256 "a119adf673df8f61fcaec841e471392cfdd9d307fe52ec9d6b3d9393846a7630"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d35c65880d1f85056bba7556fc5f773534032c80e0e6a0b6b9f84e3c878d12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f57bd17848e0bb4663aa413ab6fe9da02cebbab772bee3abbbf9a9ce8fc2a190"
    sha256 cellar: :any_skip_relocation, monterey:       "90d4a69afbd4a0cb0cbdffde5e575b89fbef100da6dd5884fcc12462c48cf0a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f496698f323b942def1bd3b0f07584b8b151729e67df50e691345dfe9abfd5e"
    sha256 cellar: :any_skip_relocation, catalina:       "4b694ad465c018130bdcbe65ea6950b70dafa3e4dfecf583642ff203fc4d592a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0172ede33b3d64d08b5bbc4e496761944e9867190e2110a49a06de49cad38417"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    assert_match "brook://server?address=&insecure=&name=&password=hello&server=1.2.3.4%3A56789&username=", output
  end
end
