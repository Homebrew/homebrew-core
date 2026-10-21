class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.3.1",
      revision: "c0d08d0d6d9424d4a14febb5e8a3e51b0dd00dff"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2ba44293255a42d4e736e58981ee4dc35aa4d1111868f8f4a4aba3490d81873"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76ebaa1d4e17459aa02de1d28f9e1060c6ac33f7490f2210ee5d5ed7eb0f5e6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "120a700cd8c66b216b785405a02be19601615fcb8e72cdd04a6dd202a1ff3ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f16e372ec512b839c5dfd032709dc8d893ee33f9fa7d46becda987ad08dc413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9906d449b62a423b5332a7ec2f8f5e27e6c7e06a53ff8543b9f559e99b69d855"
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
