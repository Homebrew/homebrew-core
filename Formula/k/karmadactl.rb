class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3d06aa71f043490991e1f76d9768ffa131e7f7ad4c088e07feafb2f587de04cb"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfda2bd92f3165e22b02495dd0f67d114574c9e3f326797fea0f6db92abc0ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b883c4c131b9bbca52aff7e54f58fb8f096b6261c4e25da7f6684b5bd1e9e8a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3eef892781df0e6cd074b05346a0e99175aed82e47e2a418fadca319a41dab"
    sha256 cellar: :any_skip_relocation, sonoma:         "abef04362bfb3d36a7ab66a855e7e2058b7909e3fac53ac023693af8e7aafe80"
    sha256 cellar: :any_skip_relocation, ventura:        "74345481a611d7d86ebe209706ba4fa5054c792b6b5925748e2631aee93fb72e"
    sha256 cellar: :any_skip_relocation, monterey:       "e4264cecde693a60e193caae711c483a9c45604c005fa73c7646241a81728a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a175b6e39703f20bb4169759ca0b9c13c64747be97c2cb645ea159f4478927"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
