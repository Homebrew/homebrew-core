class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.21.0",
      revision: "e0878d41b711792be60777fd65ad23a101e6b85f"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f59f57e74ba376302565617bfa4dbef9a84e1a201514ff19c7af2b7664e1e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54ded298c41a9a34fd66fbc183b91b408507e4fcb93fc613a3db237ac555cba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa2c5e6961bfb1e9c771eeb729dcb60ba5ec948f07ddfa13c608a53490fba34"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9c46ffe53c780aa88f48a00028350d936bebd86f969967652022bb16095388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e712583c054229cb7911600b37ba1c05bbd2648ce0c4f76b6313e82cc991897b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e292c653e8d552f73972f97cade9764d4a0c02c8b970478b62ed9f5ba0509d27"
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
