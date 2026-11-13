class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.3.2",
      revision: "8346aaa55e7161f7c547212d0a87f01367976727"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cff5caefbfd08404330a1679c60fe89a462e049af91d83cd6d89b0da7f4da254"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a40e13154a16f464555e36378de2a0a2cc08a1728d4a2d853abf96632f0c7d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a230eb29d4d682673a4aa046c353802544d81bc8f45583b2e44f88e4af3075cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81245b63a70b91ba4c1903bcbee8b777a73e95ce3f1bcb0336af8b76e7dceb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "62bc12b19b217941e36f3eefb008f49b4ca4cce51a7a8695ac6b8350fcc13aa1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `make build` runs `go mod tidy`, which needs the full module graph
    system "go", "mod", "download", "all"
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
