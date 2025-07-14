class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.18.4",
      revision: "d80839cf37d860c8aa9a0503fe463278f26cd5e2"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c68f43e2df4ab531ed61975cde488340471d6446ef928c30398c0db8ac91fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f5b7fadfe121984eb10039fee8b3084f3bc4fc0dfd72b229d4434fdccb7d8a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed6679bac081e74c68f86fdbe14120b07df7ecb827883729c002b504e6adfac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "94bc60b3db73a79a6f458748a3ae027f3bbcaa91ec5a053dfba68803addc27e8"
    sha256 cellar: :any_skip_relocation, ventura:       "f3adda674492d3eaf3460bb6e0a0fd30549bec1c8026e6fe19f50136e2e8fbdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "426bf4167cd54ddd0c46645e6022bbd964e9debc2c5cd90f6d3c2e1e6078ed62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a72704182a4bdb1530581a4f1cc43d815049ea36e8738b6613e6411c833735"
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
