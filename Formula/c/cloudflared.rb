class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.4.0.tar.gz"
  sha256 "731694e178c7671ee9210cc7aca87aa35a5f0114e834c4e83f49dbb97b2b2b0f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186ec22f0a948558dbb2090e1dcdcc9f2432d42f76c48bbf0c006e7a6e54ae50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "728197ac8ee9831c85c23b7d8f0d586119614de36dd638ed3c77c5945dfc41d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99b13bac346fe569927bafc525e84a2ab04d6c61a95cb0adfd3ba1aede3e45fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1349702e63e0178ca686871b651801c8dc41064cb1b555182d660edda56d25fc"
    sha256 cellar: :any_skip_relocation, ventura:       "ad698926ca2e309d599115abaed77546282d5f13d4819f68e54317f07150a083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f264d5f78f9c748e9f1e2572fd0f6b40e857184fff6174038e8cb3a1e78475b"
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
