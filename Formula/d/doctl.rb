class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.152.0.tar.gz"
  sha256 "c400ff8f8f3cb28e620e53caf2d1b41445334a375d0b6b679d37a715e587fe52"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138521499e52b6e07612c2189adf7d54aaf1b7e75889cc77438717d047ed596e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "138521499e52b6e07612c2189adf7d54aaf1b7e75889cc77438717d047ed596e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "138521499e52b6e07612c2189adf7d54aaf1b7e75889cc77438717d047ed596e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e0c38661f248e381473d8177b463e1c547ae39f11b54028fa6f858f6f1b14d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489c5c67041e0f78d9d6366eef9104a91d6200996489f87957336aea36b52791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e579c3c8f4fdb596eedd2e4476a8cb1af9847b164f7c98d7f37c671fe19b125b"
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

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
