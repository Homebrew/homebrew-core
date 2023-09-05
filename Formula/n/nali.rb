class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "732ef60373605491099574d875e032f864fd075d6de2d93c82cf74fad603ed45"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fe418f9bc06ea40fde09eba380059926131febb9cfffe7a1ec412f693b2666b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe418f9bc06ea40fde09eba380059926131febb9cfffe7a1ec412f693b2666b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fe418f9bc06ea40fde09eba380059926131febb9cfffe7a1ec412f693b2666b"
    sha256 cellar: :any_skip_relocation, ventura:        "d8223e754e41d2a95999d2f78ffd1894b0a3308b247a30fae0a2d5342c61c373"
    sha256 cellar: :any_skip_relocation, monterey:       "d8223e754e41d2a95999d2f78ffd1894b0a3308b247a30fae0a2d5342c61c373"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8223e754e41d2a95999d2f78ffd1894b0a3308b247a30fae0a2d5342c61c373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9e94d8b6f686d87c1cac3824a21b29c4298341b7b7a64a61ce9086aa6836f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"nali", "completion")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
