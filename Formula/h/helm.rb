class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.2.4",
      revision: "3900f434fd3ef2b84065dc04508df48f288dba00"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3af0dd1fb1e042dc50c88ae0368dc9e2f0376baea89343364c2987198bf8838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3243930f44f003b3686f4291d1e4120728027e91b923f2073361f1846c8cd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e13b32c188dfa16654ebc443e227d858e32ddfafbe9c7759fdc672d341f5c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b155ea9f4e8755ec993e4e41206b7ee39680ef73cf655de6243767752437fd4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704fa602a842b457d450a52e859f6e1601865fd4975fd881ebd5744458ca1543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb6ea8fe1dbc211b45f4fd4ab7187c09211b0344b64b9e23eea282cfe803215"
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
