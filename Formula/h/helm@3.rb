class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.22.0",
      revision: "144ca65f8501953fa8b41cd1d37c7223051c85b7"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f1a7b1fc624e109c373d315987001a2a23e2efda0c016c18acea4c835e2dd93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3441c526d8dddc67b39e75db11e89eb8dcaf627844d5b47c319faa4330b4956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "318c9ce8f6816643dfbca9eadafa67d99d9819a1d20c17589979ea998a648b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "aa3bf36a3b106371eba67fbe24ed30819336c08288c29f5f2245ddafddaf4d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a2285f215e3267668f792d55b66d33d36252b9532752d432794f30ce50f5e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c9894651d6ad8c6227570c7c46bffb51b6c3eca370b099659635296c08560b2c"
  end

  keg_only :versioned_formula

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
