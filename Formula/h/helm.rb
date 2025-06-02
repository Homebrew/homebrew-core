class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.18.1",
      revision: "f6f8700a539c18101509434f3b59e6a21402a1b2"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9661c6a0f29e54f4c1ce91b04af1013c3dd91237d88203b9d164c89f4cc0f180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca208ab577975c7a626b1ab126760d2b28f255c952bd8e05c71d2a42dbb4b45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "087dda92167b73fac74498532258993f4b1c4e7a0657169f69218d652302df3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd6960a527f3554c5dd5ffe72c4c291c16966a82fe0fb676497c4eb39d71c62"
    sha256 cellar: :any_skip_relocation, ventura:       "18541d195130bfdd48c2a554374aec287e85d0e6fbfb9de4918b5d7c86880c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c514bdfa410e2a62e515a3b5334bfa3ea58e8cb599097b6fe0d12b0ef8a8b94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b77aa7b3cea3c2dfe18d26dbe0aa6ad029e61ad435376188651158cb6a5e625"
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
