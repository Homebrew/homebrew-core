class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "ce17717ab9bb93f5cac5178f9f3dd956f3cd51e09142b25282d9ceb063f275c7"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20753966215af949f2523748721ee3f7039a4c7f86bdfff27b64a29b12302730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535e1ec00e6bef807dfac247593d8714e72cc174aa1e6b643cea0f1f0a61492f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0098af5fb36d924ce42761b95ff10e128038d4b2d99920b500e66fbc4e9f400e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6031eb994f207b910f70aafbf0ae874569b2892d712c57de02bde94be1e48619"
    sha256 cellar: :any_skip_relocation, ventura:        "07bd3127d75cd4c2b886094e7fc9af55e7d4339650f8369cf59407f6af173cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a8cd2cafffaa562faad4225a4908154a1e8d58dbb8b4cbe5b4f056eb1d0e6249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d0b82e498752728b06fe776502bd5be8a0a4336d1bb033a7c4a558321aa747"
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
