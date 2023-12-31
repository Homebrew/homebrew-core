class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "900e308cf1156b7707c2a1ad17feec1a7f3059225ba8a9728743aa9393d697db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d42468103bbc558582b3d4816802acb65b68e0ee26aca2cd67772309d978b54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4bfdf8d93fafb8f0fc09c8af4af29e8b33fb9a659c57c59d58ce6bec36e76bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df331ec16f6515519a1d98a556837235ae5ac1733a25a7e5b4039c1783816ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "541eb4e5b58f5ff9c8f70dd00dd143e9069a43f01291a50eaa7d33df328762c4"
    sha256 cellar: :any_skip_relocation, ventura:        "bbc9ad4d0b291e2590ea384933bf5b48129da649314cd6abbcf8715eab5c40c6"
    sha256 cellar: :any_skip_relocation, monterey:       "02bb4c95a4de4948d3345715700c820a4bec92860044f50d92789358cce3353b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed1075cdbe96317f8624ddff44a315b3cb78527fd74ed85e196af3a4dd08e07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
