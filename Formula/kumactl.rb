class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.0.1.tar.gz"
  sha256 "6af898d0df501c8398667f0f127bb77c379022a488c20fec7892b740377e6a88"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d770a7e2fb4afbfc90ea656ca24ff27c8bc015cbc8b4472e5fbded3109cc7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81f13a95a728df893219e9a908c7e23bfed48289ad8e9dac90a43c1cd78d6e10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "928bdc1bcc4851656960e609e99c705ad8d9158859989936532f59496d2aca6a"
    sha256 cellar: :any_skip_relocation, ventura:        "5a62180ef2c4a1b0e6b783cc6ed50f5963eceb8330bcf655086d5e3f13d37740"
    sha256 cellar: :any_skip_relocation, monterey:       "80061d500512dec3066b5bd1a7bf81e557d50888d71508e804ab2e0d2aec376a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeab41d389e0ab7fa116ff8e456f81b102ad25fd4cfc7575db507d523659716f"
    sha256 cellar: :any_skip_relocation, catalina:       "12b8ff2195f427e60756a0c6d71da90ad87592265955946d653047ea69751eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc135e88bb99b5d4f508d0f8fab8e3169347a063ed737cc4b2cfae479017846f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
