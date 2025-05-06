class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.17.3",
      revision: "e4da49785aa6e6ee2b86efd5dd9e43400318262b"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc9183844aa08e59dbf0601712dd7ebce9e3608e9f9dad6d8b93daa9c567dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "941a2e39998eece96d5d264e5c5a6be83039ee49aa23a43ea2252be79f6cb603"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f3c11d35d57ce2d8611669bc4d2e619c6c8f48a836b0f3119b7cfc6c1023c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a5dbc2737b4b5c331047e2e6063481ca5f27e9a126c355f969cc4ad8554a5b"
    sha256 cellar: :any_skip_relocation, ventura:       "47118aa666e8f83ac3425dbb4538926701673eb42e96e3df2d6e3108cc2329d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "114b712b051b18938dabdf39c153ed3cf4ac5802fa2890a31a40d36c12b87c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236a0586ad8a20b39449228e16cf287114a874f5d760e6f0df7a45d0dd1d1ad5"
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
