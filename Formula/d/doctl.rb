class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.125.1.tar.gz"
  sha256 "c0bd65a5dd7ecff92dbaebc9e809605749e8b97bcd068656929447ee87e1cb9a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35151b37f1184b6c22f61def101de5cbc2872feb3265f36b8f9a1d1e3465e7ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35151b37f1184b6c22f61def101de5cbc2872feb3265f36b8f9a1d1e3465e7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35151b37f1184b6c22f61def101de5cbc2872feb3265f36b8f9a1d1e3465e7ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "261cb75af12f9cb56c936cce5a9baf147802cfbc6f4d120a702d4c8edffc1200"
    sha256 cellar: :any_skip_relocation, ventura:       "261cb75af12f9cb56c936cce5a9baf147802cfbc6f4d120a702d4c8edffc1200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33bdd1235e95a4a293bdb6770152a23cccba7da1dc1da9055a8724ca5a6e397"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
