class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.13.tar.gz"
  sha256 "ea78f6f111f48c1429a2cd415a1867e07318581697ccefe9b525e462637271b4"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09979534d31599a7161a4434337040c91c876eeb5434e73eabc1eaf568319b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "630a8b37daacc417cdeb31b2071cbadbe20b73de26a3ade07424d5af17cb17ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c41f2c122028bf1fcc907fd44c01dbc29c60a137864a4e62a35992b409d2c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6b56725a64ba1be6fe7331c7ca484d8d611388fb770daf59e39e61da7b8514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c191f81ea9fab8a283dfbc5b59a65fea779029701c1ca8c4bcbd92e239a5cb9d"
    sha256 cellar: :any,                 x86_64_linux:  "66b93f2845c885ba06943bfa295bf1a125c6c08a0d094c1fb1369453054713df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
