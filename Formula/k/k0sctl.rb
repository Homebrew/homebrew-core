class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "9d40c1949183052fe90e4bd7c49f26d83361a454abfcec0e39f85623252323f3"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3a0538378f2f68c8a140717748013cd242ee4df2f483edba4b25245b0d229f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a0538378f2f68c8a140717748013cd242ee4df2f483edba4b25245b0d229f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a0538378f2f68c8a140717748013cd242ee4df2f483edba4b25245b0d229f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3578ee313f5e473992a7750ea07784d1192c12fab815bfb4c2216bab3d1a6948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3fafeff3025a38ca5dacc1ad0c69281797a7bab59e994b02fd5f4302d357e56"
    sha256 cellar: :any,                 x86_64_linux:  "cd550dc8973fe0be54797fa83683bee378601733115757a375e0efc95088bf45"
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
