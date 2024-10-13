class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.75.tar.gz"
  sha256 "3255b18494539bc9b7c1e17c34a98588b60f50ace8393c567f356a7eeac2d6c0"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "84bfcfb8739032572e12630bfd68024185d39d2a49dbd7295477d8e959b2fd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a50b8fa07a0dc73812573bb89ca92f9aa2ea9f688ca78dc03d95164a16b524ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176ffdf87a92e0826776419a7efdd240e70d0d27141652e3e11e1bbb1d562810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff979f73abf651138c96e1488878648fd1e637a79e5420bb0efcaeb027bb4f9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f6a6a738c1abce44c55cba84a3f7d1903c96181832f6972f9b196ac29d69294"
    sha256 cellar: :any_skip_relocation, ventura:        "c25d3b074c27dfe1053b852c45ce4b3b64d944d769d0d7e980846bf5d0708c67"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f9f6707a7167931c04426e5f95d0df4577e2c7341f5a88f44054526da39494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edd3ee12ed2d62e687bd037e504eb9aa7a97db153b833ea98a38500b6ec0ce0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
