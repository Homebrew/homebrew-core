class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.5",
      revision: "4a19a5b6fb912c5c28a779e73f2e0880d9e239a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f5160c0944dacae54e80b2c8553bb4066c5d3a42974d6e62ac262a7256555a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cdd33adb7e20a9d0de185c859485613a0c90b892ccf3f3705b4a2aa3250bcce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "392e4287d850eda37dd270ee987ed3477d9fb4229efe1cf16d762c98020a6056"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbf17a4530e2ac044b0a27af4e1a962dabee2d8239f2650b51e24dceb9f2191c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "907be6b947fd1c986082de982d1a23bc726f894d42501c03f94e2ae41c854989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f046e65d19b4e0900e0a73e5b9c3bbe807fde7b211ca4ac5bbf97c759d4ae19"
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
