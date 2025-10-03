class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "1975bf0a0aeb03e69c42ac626c16cd404610226cc5f50fab96d611d9eb6a6d29"
  license "Apache-2.0"
  head "https://github.com/pulumi/kubespy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efcc5504509a6dcb5da8b20224794ce8b23d8fc5a0401edb5f96eaee345c8ff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d88d6926bf09883789531fe1cc9956908ae7ce115ef2a4a2ddccd932ca2323d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350da84eb2954134ad621f85dd0619c00d76730835fbd03409b9d93bdff50543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f330bfacc517d413078b720bd062241fa133473261bc683d9817e7a0b102d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9759118bb4059b89ddc15eeffde235cf2f38e6c43e3e8ab3f3c0963360da5d8"
    sha256 cellar: :any_skip_relocation, ventura:       "efee99c55ca31291aab9dad8badf602a0d8eae65f201f407ec40eaed9362f1cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e00ec0730211581e28e9ce51a735efc19081821f363c0541e74917384544384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b1c1fb59db56e36ca01cfb315313a94796d679d7ae85988132f20b6706ffe3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
