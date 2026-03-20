class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "5e56223f84faab70e90f654538de64935344bad2469fb5f315dfda4c90b7a8f9"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19ba422e92d00fbbacfca1a20bbf1e8ce6af816d3c316f734583171f8c90a0d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2778bce8aac4298e60795ab7f0129571bbf0b7eacad78d4fbd5c9f4c3690674a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f66da26cd99f62d4d06067cd47013840676e7c3f90eaf588ea3023e597daa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba416a7a189f69b385af669b6f841c2d821cd63fdea9c61b9947afe94530e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccfec1a3febd113863db084e76d2f1d73b0ac3cd5fce863ca393c0e864bb63e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29bcc358013598b07e442a99c92b39f22c1fdddb7fff3cdb6a9597799db5818"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
