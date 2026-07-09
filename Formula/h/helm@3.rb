class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.21.2",
      revision: "125963406833fe0525be91f46c8b5b0f22fb9e32"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b8c5fc7628bd7bd46333fea5d4fedb2c22d52b16fdddd8e1699a48138a65af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2424172aaed35766eef6c65e782dd0a9f20f0c11b57e7c05a57e36c3733fe44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b76a298ec6c72e782eff42113de02db92e666d07a92e646508b74b90bac45a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5eecc19caf2482f154765197bfea3213885e47cd60ba6798dfcb48e728ed8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbca856e3b6bad04cde98deb8dd06ea63e0aa6be1a4f3348a852e4c3cb45a9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30c04b8c172103cac49b5c59104448184ddcbefb7e1ff62dd14ef3d09e6eeb0"
  end

  keg_only :versioned_formula

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
