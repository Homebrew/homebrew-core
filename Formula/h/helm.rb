class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.13.1",
      revision: "3547a4b5bf5edb5478ce352e18858d8a552a4110"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "387a2f63dcf48dcbf805329aaac8bee0f03d6a04b4229a782ff142cc9922ac88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1b10ac507d63b7d127a934894e5c1d1050029ead01966c1575af5dffcd20b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc48763feb2854d90c43e6ccac92a81ac3d35e94f1645beb48d9573e1a085542"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa709a1d70b2c71c42e300f48c0fb90fbf545cf551e8031d38bc7844d0467e62"
    sha256 cellar: :any_skip_relocation, ventura:        "c9088ffce28382dcd2fac19bb3400c0546e50f76dcef5d9775ddc3a4c4fa4299"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e98614f6d7077b7828104b31d52158fdc9db306855a72ce3ec88a705c20eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6caceea9247c327d208033c1b56c0cd489602ea1652bdd077d8b5198d8adc2d"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

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

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end
