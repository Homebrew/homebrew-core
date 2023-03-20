class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "443bb5d938c2abafd74a0e1d932eb5966b0f6d2aae7a784e4899c152efb818a1"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4ae190e3e81513255adf174d6f916118ce86bea0d4022e280c5d93e110b8183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d65055c352867a960b13d35d79e551ec8bd97154c615f7b68d245e771ab5aa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caeed481c2cf84e4a791dddc197863d0348382211284aa81bed8d750b66badcf"
    sha256 cellar: :any_skip_relocation, ventura:        "69e72992bda65827fd2e4576e5eac0024b8d1ecc0acb56829a707cb23228d1a8"
    sha256 cellar: :any_skip_relocation, monterey:       "90e9db3f4407880232c09555836bb88760557303bd5c998605ed17011b4ab10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "400b8d5a4b00c6b275918a588c33094b0e699d56ab149bcfc9771e514741f725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa5207552ac35a6a1a2a7386f5fed9efc08eaa3089e3df569a16a53121bb78d"
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
