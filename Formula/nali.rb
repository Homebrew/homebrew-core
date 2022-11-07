class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "42ee4b9fefdae3082e0bda2bb93f65f16d50b4b38679ae11776c8563af561eff"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b331c49ecedb1271acde3f0d1759ab85da1707e7addf2d4e02233d999bcbf3f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1d21f8121e9a1ef256626e8e67fe1b0a45f241ab033f6336490c6b41538508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23fd50f6782635f134458c84842c2180bd06e5ed62988e9af72b8e794c90c2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "e78ad61d89303d35e38f756c8d8f527dda2db5803de2339494aa2e4a34924e6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "efcf7ffac197af834a1dc2312307be3f6da99ce7c95a00bc691a8b786c366500"
    sha256 cellar: :any_skip_relocation, catalina:       "18c0323f0fd366919b5ec4e8e878c612d8dd72f3442908852e601c3d25de60f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e22f9eb5f683f736f32dbfdd4a8c5874d98bc2a18e3a87714348f734fa4c08"
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
