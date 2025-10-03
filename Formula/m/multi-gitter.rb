class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "ced06194e6ecd4de6c1abc9d61d89ffa71a6811f09122b52f0b3a42ccfa87b46"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b987db4796a37d8cebc0e1998fb1d690fbeaa1f22e3b87634e096c33cd55afc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611c3f1101d7febe7d0fc383356dbf9df7cc6c34820a3346e43fc9deadc3bb01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "611c3f1101d7febe7d0fc383356dbf9df7cc6c34820a3346e43fc9deadc3bb01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "611c3f1101d7febe7d0fc383356dbf9df7cc6c34820a3346e43fc9deadc3bb01"
    sha256 cellar: :any_skip_relocation, sonoma:        "63ce12a5d87d4417eedc231057e7053f0c357a024e08e247cca0313b348d9f2f"
    sha256 cellar: :any_skip_relocation, ventura:       "63ce12a5d87d4417eedc231057e7053f0c357a024e08e247cca0313b348d9f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472e64b63e0f21c6c616fba5e85d19459bcffc0711f48359951e66560144346a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
