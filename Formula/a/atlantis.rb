class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "0fe1f6f6577096e2d3db5f921526bd1bb70e4577239f0d453df50c386e00b3ce"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e386a1718c25f2d95400cd613bc1de309b17088be66edcf86489e8eb75c053a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14f2e693a9111ada9c76c437bc42308917392170772f45f923b0e3d55b5f8394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa73476c31aac8ab166b5089299cc9a3b21227d22b6868b9a5f7a33c686d87d"
    sha256 cellar: :any_skip_relocation, sonoma:         "26163aec7d570ddfd7fb565f372a3b8bac2be56bf61e537d7024d96cea00cc0a"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f43753b48f053d9f5e4bae1088ae8ba4ffd438b128e67ba47a15fa5a94609a"
    sha256 cellar: :any_skip_relocation, monterey:       "973a71bd240fa54226066ce3b7c0379e7513a8e6dd31380c40591b12d16e6d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72068d058c86c117d84d7f1de3115c20acae7b0460a2f039c16d1245b56999be"
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
