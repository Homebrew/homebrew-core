class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.2.2.tar.gz"
  sha256 "28bccb9a99cfcccade673f1c14cdbecc5fba7ab58fa6f1062cd671d749904ba5"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17cf5f35c9db724bd838525c4b3d36296d43ee52eb9f86902402b71072e5a8a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9cec738da0a17d245b15ba3c069db85346892b1b62b2d54d2b427a6369b7b15"
    sha256 cellar: :any_skip_relocation, monterey:       "59e79a1835b61b76723defc697fea26756bd2f818851edd457553ce988e40cbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "07fd9e86726ea9802d7efd9adeefa39b17c66cfc6d4d272b848c663bcb9f7a7a"
    sha256 cellar: :any_skip_relocation, catalina:       "2fbd7d4dbad6a8750442b207f3ab7b0072e72bbf33b9b68a64d2c1969a154fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818c618fde4965993dc467b6dabd615bc2e26f9362a182c92619bf0857c8b151"
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
