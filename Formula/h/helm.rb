class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.1",
      revision: "12500dd401faa7629f30ba5d5bff36287f3e94d3"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15b1c8b976a3571ed15c9a39ed535e9eff38f54d78a60642a213537a5583f7f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15312ef4fa6dea626831e84a4a0821d40369cbcd77b610605bd5975982c52c88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4157f1305a1c224bd73b1f76cd0077d4b8260cadf3bf96b38dd72943145c464c"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a26b1ae880232dc680da3aa6000a8b82b4b36f4c5e54a599dc097578599cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569aa36b9e778c013e4389c7d6b5d8a0eb73e7bb26065b639c4c9e178573181a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabe32fd85f67dbd84fb45139f0abc3a17ce60bc0c2bb65ba7abda5547bf6ff7"
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
