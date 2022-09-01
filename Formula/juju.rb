class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.34",
      revision: "20b8212e62c5d122e63141825a7733bf66c4c5a9"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f35492b9dafa71d3a97cc76bfec1eddf0190acba8cd1086cfb324eca3818936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fc6257a6e5d209e976e4c2678aa5ef8adbe4b2f87e580ad48393a9e9bcce21f"
    sha256 cellar: :any_skip_relocation, monterey:       "8563efa17e5c843c7febc22ae9910502de72b01d069df07a78aa2ecd8371844b"
    sha256 cellar: :any_skip_relocation, big_sur:        "220c0f091e9eb770703ebd900fe9519b6ddff3a3f309580434addbaf60f6fdaf"
    sha256 cellar: :any_skip_relocation, catalina:       "9326d68eb9b974e8da4dadf442b250be46592ef3a6c669b493c5fc7f88da4b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6f94c97db33200be3945dd49f6349fb909d50d70bfbb08abed22f8767c56c6"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
