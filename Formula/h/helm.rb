class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.17.0",
      revision: "301108edc7ac2a8ba79e4ebf5701b0b6ce6a31e4"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f590a9aabea8fcb217e343f5c87416a59ee4157c3d46bb83518e5b45e7bb83cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7664f360847c86cd14bbd77abb97a02f1e5c124121911b9a00f25adfc731ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1b9f49659cccb9f010fa212bc97b10e2411837ce75414af12dc277e08a49eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2884e36e7a97b4193f0f83c2ccb2a286646e25dc9c6d5deb81676efec7aafe0d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a32f9e789ac22eaf5be9688bfc8e80972b2e44d1dd1c826d543cb6d239282fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e1b834536e9cddfba62adf3dc507efe57c24a2f68b8a8a1a4de6215a326d99c"
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
