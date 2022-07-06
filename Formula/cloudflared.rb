class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.7.1.tar.gz"
  sha256 "3a822faaed7ae90be5ba4920f9226cd85367402d2c5a2bf2f0732c37cad6599d"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9503744e54cb1c90d48742f5833bc20de1d0a752ef8e636be04fb93897632bb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f720d50eafd78e8d44d3c7b9fe228f3f82d81c0abea5608bc92315544eaac25"
    sha256 cellar: :any_skip_relocation, monterey:       "187d5957d397ab6ceda6b59ec99eb399bf6b432b4952a29448af0fd07e9b57b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbb6819a43b421571089b5e8f7b0d8fb1119fae0816d35f4fa470776f5fa047b"
    sha256 cellar: :any_skip_relocation, catalina:       "f8ef5b19757ffe957e84ec309c1872b85a7ff0694e851b8f0e0b3abf72284b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d994aedb6959af1399276da0c2ed5cd6218c289b1d23296e31b1296f070a85d"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
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
