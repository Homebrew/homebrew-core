class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "837b096de0278ee2a539357a0cd1c56e827c1bbd53be5822df5404b007ce12f2"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d84879462bce868f528f48d204099e962fde9e7f3d85624729203c58e181832d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9347de42fa84242c37701575c975a3ffbee182c9304dada883e3874e3c10e1a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939e965d476cb1f851b4f8e9ee1fdd0d56879787e7dcacb9787db995efc27447"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1ddd57821a6348d35b5cc908df7763ff9ea7986d2ef8058952f18c4a2457e39"
    sha256 cellar: :any_skip_relocation, ventura:        "84834291c3168a8b73ef17a2d64f380ef050ba3997ba26b6262aca28952ff2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa7234c0e817203a66b47eae2467ec67af473a3f3ddc9edf1cb41f8516a163e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9eba05014d5b3f1884b8e0fcb7cd72a8c484ef3243427a492124135e428ccf3"
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
