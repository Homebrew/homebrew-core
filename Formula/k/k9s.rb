class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.5",
      revision: "1440643e8d1a101a38d9be1933131ddf5c863940"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "71834a17a7a0cfb4855553c7c99217cd39434c756a420a57e47b01128cfadd97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b96fe20b0004ed9f2a6733043d65bfdcbdbfff5470ea8531c6f49888819f48e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc659225c3b753e87eedd2d19d2f5d54db55b4c504924095fce8c182bbe044e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bccb8d9998a875cab724bd11e7510e5a930cbc0b1ade3f1522b0127427adc01"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f4bf7e0ecf3cc4414e491403d5e24be996fe525f52aba1509c8579cbfd120c3"
    sha256 cellar: :any_skip_relocation, ventura:        "5387789b43544fdd2328cfa5d9a332f620e1b0daa9e753f9eb6780f20fc5c0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a76ab5bed463ad3cb0729d4363641debd25a324016dbe77c31014abb61d87c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7976a912773c66e26bac3c89e5886dc369f2d23f34efc916f76ec28a16e5c5cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
