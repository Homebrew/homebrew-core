class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.5.1.tar.gz"
  sha256 "12e67020a477a25a73ffa15a6a48b1df0bf4c43137e51f59a760f55db624e150"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07d5ad0e05d1fba699f22b85ed6d9c75ce627b773677939facca290bf98cf594"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07d5ad0e05d1fba699f22b85ed6d9c75ce627b773677939facca290bf98cf594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07d5ad0e05d1fba699f22b85ed6d9c75ce627b773677939facca290bf98cf594"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eec7286ca7f14c01ee0e19d62cd619f40d3b885e7a7966fe43662c5cd65a2aee"
    sha256 cellar: :any,                 x86_64_linux:      "4cb2f2c18d8302f22afeb1fb5589d8094c5be9a72a32185d7b46a19b9afff73c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
