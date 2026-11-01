class GiteaImporter < Formula
  desc "CLI to migrate repositories from GitHub, GitLab and Gitea into Gitea"
  homepage "https://gitea.com/gitea/importer"
  url "https://gitea.com/gitea/importer/archive/v0.5.0.tar.gz"
  sha256 "11c32c509b9ad471f9f00f54a9968acc830ee4e8510be30cd7a879d8b87f8ee1"
  license "MIT"
  head "https://gitea.com/gitea/importer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90402b0804baa7c5362233f0b71faedc778dc9aa4200246bf34b686a885b6cd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90402b0804baa7c5362233f0b71faedc778dc9aa4200246bf34b686a885b6cd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90402b0804baa7c5362233f0b71faedc778dc9aa4200246bf34b686a885b6cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "052221f58387eb2309d2e016c2b71ef9143b2afac49b3b158b93b1b2582a3968"
    sha256 cellar: :any,                 x86_64_linux:      "b898b781db0d2aba3bcd0c6156077f8982fdd5cf2b43ac21e340cea3ca3e7b37"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X gitea.com/gitea/importer/internal/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-importer version")

    output = shell_output("#{bin}/gitea-importer scan --source-type gitea --source-repos foo/bar 2>&1", 1)
    assert_match "gitea provider requires a token", output

    url = "http://127.0.0.1:#{free_port}"
    args = %W[--source-type gitea --source-url #{url} --source-auth pat://test --source-repos foo/bar]
    output = shell_output("#{bin}/gitea-importer scan #{args.join(" ")} 2>&1", 1)
    assert_match "Get \"#{url}/api/v1/", output
  end
end
