class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "5eb2d2d5702dca0619ccd92646f58eba55347b069fde51ce06845a96a176471c"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2163f47d60d07f7f885de163275304272ea397403d89ee73d99856c722e6379c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2163f47d60d07f7f885de163275304272ea397403d89ee73d99856c722e6379c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2163f47d60d07f7f885de163275304272ea397403d89ee73d99856c722e6379c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf9034878964febbeffe145d41846309a19488e73f943744abe23553c5e5b829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11d5d105eba72b5e43331f90c5b08996d9430e55a5ad349a64755801b44061d0"
    sha256 cellar: :any,                 x86_64_linux:  "980ceda6145f73afbee71d4695028f602378a3b4b86d8aec33c8df2ad5b738bf"
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
