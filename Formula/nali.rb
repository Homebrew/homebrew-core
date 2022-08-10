class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.5.0.tar.gz"
  sha256 "fd3dabda33a381d0072f9c657098c3c01c793195bc6326015b36c8a168943f1c"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c874ad083efbca720a668e07bbf9eecb499bee273f64ffa2ac8cbe3c1342aba1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eb618cd6ed25d8f4ee744eccaae11dd3f3bba89a49ff67f64686bbb99d832ec"
    sha256 cellar: :any_skip_relocation, monterey:       "19e362fcc1905828d2297e1b11d97f7a0c802f323192d530370d8b4bc49a65ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bfc642e53e56d6cdc5cf872be552fe85e427482dfe1dd06f6c03089d17a85ec"
    sha256 cellar: :any_skip_relocation, catalina:       "59782e1f2332781f5f28434a0ded16d145b4bbdfc4ceafdb3178a6b5aec0b8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8dec59bd3ddca451e89da327c5be991816162dfc2cdcc34d3d3305af47f01a"
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
