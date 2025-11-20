class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.2",
      revision: "8766e718a0119851f10ddbe4577593a45fadf544"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8873a2f317dbcfbe2d5514e16c6e0dfddf1d55fd4bf3955dbd6ef692aadd5e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe38f14296cc3ffa4bcd35a142641c7d3043293662dd42cc0ad405b3ab104c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70321d70be984eebc9f35c8b5c3b55f0dcba18197feecdd0a9c0eea0ffb4a4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2853045bfdcf7b3ee2929270ed5ec574d3ff8aa079db55d8f06ca0386018dbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf0fd686f862717ec932c9ca8190c9cd3c390c3b9ca184b90d1ed41fc7b01ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e298e142a0a7379a9f0896b5094f90060322275c7e045ec51897a84ef07534"
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

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
