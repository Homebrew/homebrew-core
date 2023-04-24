class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "58d53926ed17690b7654831ee7cbbdf15769caa2344b53febbc15b6ea52b889f"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7b92b8834fa0946662410e85449bde8eea81e4156b3ce517f9e07652a9b16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf7b92b8834fa0946662410e85449bde8eea81e4156b3ce517f9e07652a9b16c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf7b92b8834fa0946662410e85449bde8eea81e4156b3ce517f9e07652a9b16c"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef728d0f6eddccf5413c322b75d779727ee988d835d5b3d6804b8e87f2d604c"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef728d0f6eddccf5413c322b75d779727ee988d835d5b3d6804b8e87f2d604c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ef728d0f6eddccf5413c322b75d779727ee988d835d5b3d6804b8e87f2d604c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86af91f23bef8250b4c759563aac6f520208bc352fdce3bf796bbcfe253f002b"
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
