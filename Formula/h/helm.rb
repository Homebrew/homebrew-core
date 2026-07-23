class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.2.3",
      revision: "43e8b7feece8beb0fcba47059ec9b522fd929a64"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3886ba32718e6c4a84cdefa39360f09cfbc056ed5a085e2cbdce21d8899d8ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9eb79771c74245866b692741965a4df40af1d65c40f677331d21ee2ce04031f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "332a9c1f97927831fa36e003c2f9632f9444ad42713c826b2fb271e4ac5caa3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc52c2d8dc857b528c2b2cd236613d943c7f5cac5f6a9792077411abaa411fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b6f5e871c3f88895263df17a90d54a150032afa055714e1fe761288ab0792f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb4faffa335b0ce9fd5e61b6b6723b1b4bd5df06b88fda135009ed556ec2f71"
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
