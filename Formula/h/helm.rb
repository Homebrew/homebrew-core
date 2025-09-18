class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.19.0",
      revision: "3d8990f0836691f0229297773f3524598f46bda6"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751fcced921cdf4b4b02643f035b9f27874bca9d7d9c3684b2564bd26980b0f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f00fb90fd56ebf1db1b69afc497d0a70cc71fe07c1265d0daf5da89e0519e16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2206a0f6f98d2582128c28b64c977122adee22aab08d2165855d858d6b639a9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0cd504f2624a4112bc248254549e354f2c9a7dcde894a4eaaac37df1f0c6b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "364e1564b06cbae7981a6116694fe8a53784463bd04017f63534b967c56a8155"
    sha256 cellar: :any_skip_relocation, ventura:       "3142bd9ed1d00d6e56f8210e234a08985caf8b54382eabddc0ddbfc1c51c53bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ffca6611d2fcaef2694e166714f18c9a1d3e33fcb6dd4308a2af8a3cc026de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb173d08ba3340bb4a1d15e27df2b7554a11d16eee3050ce113b060f228dbaaf"
  end

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
