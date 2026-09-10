class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.3.0",
      revision: "bec5b06ed841fe5269972d864d5177944fd5970f"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d2ca7fc3689858894d282d899c8ac8f1b7160a3f1787c2319e8e3c44be95f23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0416a77bdf3d1bfa343bc05dae2f73fb81b84e849c2ed33fd7b261675ec9ed27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50a76969ec8a987a71d5cb8f64ab2ae2670d564c10341f309081b7333fab39e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8f7b2f51e3918961b5496ed9416d075abf201da84e822d093358e6ea1d611ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32eee6c777495a94f4775bafd5fff96e90b4c612dd47885b60828e65bc0dbc69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e341bda4879fe053fa33587dfc95b2c420670755b9e819809a48cf007cba23d3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
