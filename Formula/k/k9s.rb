class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.2",
      revision: "394fec34531b36941a04a93fd458258e8d672bfb"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5825040f243e5cb9ac8cadd54d81434752ec61f43ebb671b344a87f24ab53e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f41c9886618ab7b08c3569fbbc823e0e705eb784d9a21cf3d9c1be1fe326b38f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f7194ad8e5cf0079011ddd5d99ba0d27fc40d5b4308d19657a7d07aecc656d"
    sha256 cellar: :any_skip_relocation, sonoma:         "85352330bc69f19161ec590649fa163c63b7e7e34a83af08c50e79d8fe55d88e"
    sha256 cellar: :any_skip_relocation, ventura:        "405807ee19e92487f9570353833f89cb6652ae81016243a07efdee01a8016315"
    sha256 cellar: :any_skip_relocation, monterey:       "d316d7d5eb3ef37f49f030db1526ba7edabe59c60ce90aaac62a42b840bf1ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f571307c0272db13dce66c05e10c13a7c416fe5c14d603a5f1848b867652380"
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
