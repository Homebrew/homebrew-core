class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "07ac4ec56918dbf11a160addfeace033802358cb80b20125f68b937bf6e3cf3c"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cba57bccd0aaa418833ad59cdb99b3af9e33b9697f53ab19d089a062dff08dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a758e4b7ea80bee9fad71af0673ca52ab96fcae1905b5eee8329f08689923ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f115967cbd95c2e242d93afbf1a5ae98a119645e0de20d9a8cf25c619525f05"
    sha256 cellar: :any_skip_relocation, sonoma:         "96d691a8fbe87d112df2f57e2ee0c09260b4c1fa6fe6d38b3ee04d249fd0427a"
    sha256 cellar: :any_skip_relocation, ventura:        "d796c0398b3f1c4058815e9ab70b8e6a75ea088aeaddf992ae6e6384e3864968"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1c87c6f47f00c52825db1dd36cb9648fed23dea4744d114957a778f75d79f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "530a3fd90ede9e2bb223a9ae5561feb35c2e57d2a9822d32e22fa1e68bfb5e41"
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
