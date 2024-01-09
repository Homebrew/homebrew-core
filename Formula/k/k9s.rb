class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.31.1",
      revision: "91f080561c37d721efdcd5f730874964321ca438"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82eb9820a78d3c38b549f8c6281c958c0457c2c90bc989b36ac6059a691b1c48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6680e8b8074cff01539d6d0522c90c3baee9250e116415483ae99cd135c526d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559f66a1a366a491eab362384ed9084bca5189d1a55d5a398a9d2d92788083a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "05d119ef34351c4502f52169eaae9cec797e9666d4f669c46947ff68babdb7b8"
    sha256 cellar: :any_skip_relocation, ventura:        "041538f4e0af5d04134b2b36bf376e303b6d18ad650b884214d564c727f72cd9"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb31ec55d29ddb92e4eb05708b3416a0e72c26d16ba61462a0e6365e55a980c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f75eeda40e4aceef71e5ba3f2928169d8690255347cd473bc2767152c7689cb"
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
