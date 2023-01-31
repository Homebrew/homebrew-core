class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.27.2",
      revision: "3794a61eaffb5ccbd68fe128f7216db005d70f6f"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a10fbd03a3e42d42e3a7ace6e4f4d468e4f1c59b95b4d13ea84f8830946e8a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c8d16f062466a849d449f4e574c9f7d524d120f02183b08de216fdb73b39bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddb7e225e764d9160d78d908e0ef6be9951691fabeec6707894f9ab3075a3b10"
    sha256 cellar: :any_skip_relocation, ventura:        "07b590d34aa4553a626627b542c37fe7f8c0dd9d5f5ddad39a4fc16f56b9495e"
    sha256 cellar: :any_skip_relocation, monterey:       "355dccccdf8415de3c529b20b2f1a7e495461d48e538342f1e4fca1a627adc0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c06871a3981cd2f7ff1de2d0583f28c377eb8d1996ad9598d4aa049741ece2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44ee7532ca79e8635c07cf7ac3b4a08f44b004ed1d968891b927ad9aee8801c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
