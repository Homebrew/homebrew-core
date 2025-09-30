class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.10.tar.gz"
  sha256 "d5604ef47d31abba42814876b637105f0b1e9b9167b79206aeeeb2935f102102"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "908c5f8ee50915b6704721d74117c29487173fa669b3bb145ec015757d57795a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e02ca6ccfea6c329fdc8aea963cc41a9ee738b6c0bf7a964b1c5e58ae991c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7dc7d7be800b66ec11b4260f73239e3621a2b0f3d4ab23aeae5fe878da822d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f927eee3609a32163c271a9b8b52fe92cce86a0368019810b25842c528e5eff"
    sha256 cellar: :any_skip_relocation, sonoma:        "3391af85ec776a401da818f6ad2ad92d9523c3dde7ee4294b73ff2600c1e5189"
    sha256 cellar: :any_skip_relocation, ventura:       "b7f51d9761e65e6e9b7d88ea6c10d3bd7945a67b75c708927f0d5ea4a01c1410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7313ba7bf016bbd0f5d7cf7de38fe070336486ad1f26602f21555c1ba48bb15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa2936249c4e000ba9e0620382b1b6c9015523720abf641be6be0d409f234f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
