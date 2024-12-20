class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.12.2.tar.gz"
  sha256 "48b9c54d79419d0489baadb8cb54d5196e0ff17650fb9eff81de02989fa8b009"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae701d87da791ef18f3b629f38d4aea718664dbe55bd803b6e576a6bd7a72e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02785c2d9901232700bafce8ae7f27ffa1116d8dfcb779a0a3672af704b57aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1232d86b6fc38ba4408e6715a0b38128a199acb40c21329bafe5f3b8cdd64b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "75891435d6b3e5c35f9a7de70645f5049ddc31863bca3beb4981edf48a789c10"
    sha256 cellar: :any_skip_relocation, ventura:       "605e6163b1d7643f5f1c447869b07d7692be5dfc045cd7040b1d081cd9a30ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc166b5b8193dfced211525dbe6aa08d3273c5822e9c4e556f529258b1bf0c3"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
