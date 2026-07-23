class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.306.0.tar.gz"
  sha256 "1f68f8e10eeb65c3fc9ae5dea654bb57f916f0cded33abc0207ceda1fccadb0b"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5f090c6ca9a1afe8d4718d2e4c70a8ceeb7bc8507c5ed995cd8d7c8518e898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e490a6fd8a4afd3ac2c9271e17b4d9ec97faca07b081f8d9d9ac6b89ae77d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9efcc2095cae4d5a726c4e8468e8792b93010e88badf5d5d1aa2db4f1722d149"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ea07351a7422bca676c30c117f2fbd31f57c7bd1c28ded4b12bc6c206a6dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020fc2212e3f0ec76c4337678e1964497d1e5b1bea276c888dc93e56065fb5ce"
    sha256 cellar: :any,                 x86_64_linux:  "9c05c16b0539946ee8a4b3f1c66e5f110daeac1679d27cd6e65d95a95bab3a49"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
