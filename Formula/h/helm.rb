class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.15.4",
      revision: "fa9efb07d9d8debbb4306d72af76a383895aa8c4"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78b0b1f06be1b74dc16d63ee534a448794bab86d7c0edaa6ace14e782837c73e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e7f3a284c12b3a3b9b078b17a94b4f22144147cb985581db046b81d9d6a3cec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bdb344a18a4cd2e3c34acbc03b8e95cc8432914f0dc15972bccf41ef385e697"
    sha256 cellar: :any_skip_relocation, sonoma:         "49c3b477daada863ddaba962afb61636335edc5575471c840d8e5c54904e62a5"
    sha256 cellar: :any_skip_relocation, ventura:        "9cc434835fd4509d759bf11b7b7fb7cd14c99b184f2953acfea661efabf73a3b"
    sha256 cellar: :any_skip_relocation, monterey:       "aacc3a3269573c95323e4b38dfdffcebf1b46e701929565f0aec79a46c8567b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a84839615fab01d818a02d68c646a2662d7251daa31bc0fdca2d3b685edb576"
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
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
