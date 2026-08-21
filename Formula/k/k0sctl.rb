class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "0df9d24cd7a04b039c31ed641983c41a8b23cd26e17288c9cda099f4f271ba54"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "678e0a0ea9bbabdc8a06906213d3b61dae9b63a60343589e3368102cda21be9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "678e0a0ea9bbabdc8a06906213d3b61dae9b63a60343589e3368102cda21be9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678e0a0ea9bbabdc8a06906213d3b61dae9b63a60343589e3368102cda21be9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a7b00924d5b7323c0b6c0b6b6a32bb77b6dc923cb2f76a61313cd94fa01034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd332187befd5ce1ebf664f8f1a37427d682292a09dca97b1eeedb91b78aaef"
    sha256 cellar: :any,                 x86_64_linux:  "5a0073932947e6af0f354ccee5a9d37b67db5970a9502a863fb6397ba06a3fc5"
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
