class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "0106b84cd80db5af0cd6796302904b990c908a8bb76baba07e11c944d66bca52"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f64f8eb78e39a76c1aa03141b89848c7b168415ecbb53a9ef6151f9c9b34f5a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f64f8eb78e39a76c1aa03141b89848c7b168415ecbb53a9ef6151f9c9b34f5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f64f8eb78e39a76c1aa03141b89848c7b168415ecbb53a9ef6151f9c9b34f5a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df43757bc601b51fffa82e48ba0ed667a349c1064cbb200b50f744f24bd77ddd"
    sha256 cellar: :any,                 x86_64_linux:      "15ab9327be914beb2671ef18f82aeacfbb3492b62e37be2e22ddec87b6b4777f"
  end

  depends_on "go" => :build

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -X github.com/k0sproject/k0sctl/version.Environment=production
      -X github.com/carlmjohnson/versioninfo.Revision=#{tap.user}
      -X github.com/carlmjohnson/versioninfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k0sctl", "completion", "--shell")
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/k0sctl version")

    output = shell_output("#{bin}/k0sctl init")
    assert_match "apiVersion: k0sctl.k0sproject.io/v1beta1", output

    output = shell_output("#{bin}/k0sctl init --cluster-name brew-test")
    assert_match "name: brew-test", output
  end
end
