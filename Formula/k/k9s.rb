class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.3",
      revision: "00213115bee9144cbab452ab152c911e431624e6"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c52e49a069849b1fc735f24ecbda04cb34fa269d3f629538b71661e379a8aab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92cfc4fd79d1e3ef60ced66c485a701e353586859365a3051009743a9bda7fd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9d1ddf7f0a956aa9c535dd13ababcfc8468abf28b4376415c127d0bfac9125"
    sha256 cellar: :any_skip_relocation, sonoma:         "2377ad1246853afa6bddec81f27d6f42d5b66b68ce411dd6a9314a04900c4102"
    sha256 cellar: :any_skip_relocation, ventura:        "80907363a964d1e2599d5e8202901b8f029946dbaf1906810442fed2eaeecd1c"
    sha256 cellar: :any_skip_relocation, monterey:       "79281afee0ad80313407a372abd7c862149145bf3f9291ebaa8984d3e294ae5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "341529e6a6d112a78b1e8534430d8d6d787ee342fee0d14bce8af80cde121ead"
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
