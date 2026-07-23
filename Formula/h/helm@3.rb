class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.21.3",
      revision: "1ad6e68924fdf6fb0c7dcef8e9e1dfc0f36eaed6"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f83a386b779309ec081342c20b6bccc2d4148e136ccd853cc8713b2d607ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbbb4e02076e0ec43e8c3c529f04af52798ca44e30d502035f5233cbfc3cf97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87a3bc9b86a090d3d62ad070ef0430959afaa880262883913df12d20e0aaecdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3f20bc9bf8d8374683611101ee9e406dd1f825fbb057d220fc1bcf3dbb9546e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ffbba2afcbded08c4de8fd21b6ad056bf2557892081e16942b6269601d325d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5454ec81459501d34166c671716819333b1c4da71be32a5ad9637d14b9982c"
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
