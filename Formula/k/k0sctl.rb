class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "b8d75167f3083c88417eb2b0f7d5c04283427f46dc789e06297eb7befa401837"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e99c65a828389dfe808ba95cf7f28cf7153bf9ab8bcf2ad206081dcccff5f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46083738f27ebd0b0d0a7bdc4d762dfb5207d03730520558f60e0161a4e24f9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285103e5908a040ca9117df01ff572a8170c429ea9582720245b8aaf9a66d9aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "953d77d19bdfe294b23f9e7d380ef9f79fdcd053286150d58b64eaea4707dcf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f8fb1befabd9d07fd0ea8b98005e08674cf4fc49f39da18ba057d605d8c95f"
    sha256 cellar: :any,                 x86_64_linux:  "5daf618452617d64e4978c3b489dba10563ae3904831da5e46b26405a5553c64"
  end

  depends_on "go" => :build

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -s -w
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
