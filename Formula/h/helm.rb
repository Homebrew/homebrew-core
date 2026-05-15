class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.2.0",
      revision: "06468084e85c244c712834933d25ea232a4c2093"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db869361ff24551d21564f56b151dcfb4b0c1488dc6c71e864bf1f3587233caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0dfc0069432aedf09ff9d07ad3f4cfda6959f6e5b6a9f0fdbfcca177e59793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acfc6210118225595a8928513f795f4b5067f7769c41f00930ffebd5bae06bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a8652d7dc384d36be7fb8d79dcaf538f4715d1862c32af24dfe46366c744f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74383e4caaebe366a251e005511074410c2fe178f441f9af571cb4ae2c8029c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6432112437cdf9af2f680e34d96f9a87f6c0501ef4ca1697f9768301dbaf3103"
  end

  depends_on "go" => :build

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
