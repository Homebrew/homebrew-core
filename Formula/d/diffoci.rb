class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "86ff1f7d0a91934790369184fa88b5402c5b7b0ec87358c915b2fb1e97bd5c0d"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312997c7bb2b42aa19919b4800ffd077558236548791b8f798135de2e7924112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94baef5d5a95a35f21622becbf6e538c1690c2266477ed37e240e4b4200e9253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94baef5d5a95a35f21622becbf6e538c1690c2266477ed37e240e4b4200e9253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94baef5d5a95a35f21622becbf6e538c1690c2266477ed37e240e4b4200e9253"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0566a0a0f19b46e4cfd41f8ec6f86480c841e0295bc25ad90604c0846c352b"
    sha256 cellar: :any_skip_relocation, ventura:       "b9e81c35c29ae56494fdfab84567ab17b9e0fd993de2e9c4d91a77fd63e0d3fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "445039f35a22af5204e8576d3c59e102067a80b53e1fa4a6b86585fce4f847ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2aad3bcf108466ce3eee0b7b541c09d591ccde343be82dfeff606af7d62dd2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", "completion")
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
