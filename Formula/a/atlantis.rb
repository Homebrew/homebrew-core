class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "e44a53d4fa43cdaa88a2e7734da2854a97b1b555a425ab26ac5787ef9f3d3076"
  license "Apache-2.0"
  revision 1
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35b840627fec1733d802157914dcf8b3b4a229d2dabefe483d83c1080098f26a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdb4008b963978d8800188fbec3448fa00040fd52e8c450543bb760c2567f3b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ccfccd60aef7b41012e5a8fbafcdf62ca54bf0c5b0c3a783d67784a4ff0d999"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a10883b102dff7471c6eb4cf4d5c9167495077f883f9d7e58019d16f0865ea"
    sha256 cellar: :any_skip_relocation, ventura:        "7ad13d476479fc9500f9121b8b8ea4a4ba8ae82fbe5d3422da4584c81327037f"
    sha256 cellar: :any_skip_relocation, monterey:       "e3f5d433a08a17f44cf66d004c66a2855a8d61db1dc613f383fd5996004c4426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb0f0a22b31f42a7d079d7dce8c4ba809d1872902081c2a248cf497a2b574ee"
  end

  depends_on "go" => :build

  resource "terraform" do
    # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
    # Do not update terraform, it switched to the BUSL license
    # Waiting for https://github.com/runatlantis/atlantis/issues/3741
    url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
    sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
  end

  def install
    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"bin/terraform")
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/atlantis")

    (bin/"atlantis").write_env_script libexec/"bin/atlantis", PATH: libexec/"bin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
