class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.5",
      revision: "1b6053d48b51673c5581973f5ae7e104f627fcf5"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe1afe25e02469e3f21988281140479631935288a55a8129076929316c106dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2a3f917e977a6f28575228768c59b4a36847948966a49b912f3e0d32c983a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c69995434c4ed9c9eafaa5bc1b80ed58946341aa5c98d18b1ec62bae3ab17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "11aa6cee8798ba772392f2b77a085ee53d460f07317cdb1d5c2853ac9a6abdbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a77c766a1f274cbdc8daf4dfe125f70f47d5996dbe026c1f2138715a2e94d127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa8b944b9f5ad2c717f21595ef3105c07e430d9ed68023436ac1ba4b093693fc"
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
