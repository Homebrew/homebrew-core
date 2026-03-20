class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.20.1",
      revision: "a2369ca71c0ef633bf6e4fccd66d634eb379b371"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d42ac3a8731795af22bcb7a3a190928eeb24b1bfa0368a609226ce6f2a0b39d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a650f1baa25287bb6db193d5512a3c92cb95468e23cd531142bb02c151f565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e173e586d54bb8cb94603dad28731d8be8121ca3f3cdb46c729a39396611145b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87206e32fc73162d1cac299540490b14a2bacb0582d7fe6f059179db219bc82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1515324d82fdcfbb7b8b3babaf54e19b2583e0ed78db4edd919d87079cb9379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d13195980e52a4d01a33b3c3fd79e2e49c90cdf4d8c03380d01fb44ffb3d4c"
  end

  keg_only :versioned_formula

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
