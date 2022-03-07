class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.3.1.tar.gz"
  sha256 "e3459bc83d9749d89d93e6ab2dcbc51872568d1fb144d7ab7d3656b29785e364"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7504b24c0c8e55401c28c37cbc13d8dac5350da19c3c8f6172434ac77ddf4095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c46170175d6edecd0a995295fea42c687ca830bf5a64800f3d29381d6ce8a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f84f3ff19cdf63fb4a23c633c0445655172061cbeea1d8c31de888e98a8ca8ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c3a53ccd2c51253314bda436942337d62ac70d9151d6f56287551d52537a4e"
    sha256 cellar: :any_skip_relocation, catalina:       "6e5d95aa30f2bf057c9f4a1ce0337602a91ebef9ec1e024b2ba2147e82342302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab433e9adee1d862988b64e0a4577277f5216303dd9e65b2bd76c5eacae68fd"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudflared", "VERSION=#{version}", "DATE=#{time.iso8601}"
    inreplace "cloudflared_man_template" do |s|
      s.gsub! "${DATE}", time.iso8601
      s.gsub! "${VERSION}", version
    end
    bin.install "cloudflared"
    man1.install "cloudflared_man_template" => "cloudflared.1"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
  end
end
