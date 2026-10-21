class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.22.1",
      revision: "d6c1a0e4027caa6abc7892e7ea9f0cda7447baa3"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9c46c273263e43c5cb3502cf39cdf8af6706daa33bd4cdd0a97b34d6a109fca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4256323bc6143e2593bbb794cf852736f23b0a9b53e22b2f0843625a27619f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "837ca4f9c9dc2f6a75764403dd7e5028d6067bdaf9706fff68e77321fab97ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64fc0c0613e091a7eca078ce76e4191f612fc6697b4f70a98359923ac11e3636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "83da0d582c811f39f24d8d30ca80b000586727c4088de8c855ded85ee2b2538e"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
