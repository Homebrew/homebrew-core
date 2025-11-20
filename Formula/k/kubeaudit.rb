class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "90752d42c4d502ab6776af3358ae87a02d2893fc2bb7a0364d6c1fdcd8ff0570"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "848ab7b58c3d68cc9f56299acc1067d2bcfd75b05848d542b5c6e108abbdc0cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0e3522037f91f1ec9aaff02d095c6c9da7cd4b1b13fa88f7531d7be68f880432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "009138418c76bbb04d6a36a782c0c5723716f96490d97d97787de7d86862a4a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009138418c76bbb04d6a36a782c0c5723716f96490d97d97787de7d86862a4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009138418c76bbb04d6a36a782c0c5723716f96490d97d97787de7d86862a4a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1bf1c8cf11944344d9002d983def83ba27189cc5f29f248afcbabb1c2db6750"
    sha256 cellar: :any_skip_relocation, ventura:        "c1bf1c8cf11944344d9002d983def83ba27189cc5f29f248afcbabb1c2db6750"
    sha256 cellar: :any_skip_relocation, monterey:       "c1bf1c8cf11944344d9002d983def83ba27189cc5f29f248afcbabb1c2db6750"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "503e6ad415a466e260758c702b91a589a1324365dfccbd77819c1e0702b37f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c94b606075a297fd812aa94fa7c8c95f5cac0dcec866d0f3d6d7c6ec6e8a74"
  end

  # https://github.com/Shopify/kubeaudit/pull/594
  deprecate! date: "2025-01-10", because: :repo_archived, replacement_formula: "kube-bench"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubeaudit", "completion")
  end

  test do
    output = shell_output("#{bin}/kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
