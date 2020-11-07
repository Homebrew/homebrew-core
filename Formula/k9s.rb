class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.9",
      revision: "49855b6f808c293cac02f199104229aefccf0d9f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c0051b59b74c44f9827dbc960233a3ba9434bfda6574716c085dc5ab13be4f3" => :catalina
    sha256 "baca65020b03890de262e2fa7d500f6f829369ba6688bbea43ce12ab2060d77a" => :mojave
    sha256 "7065d07c56778c5209f0f58a5c2758f908d440da3be4e8eea22fb790209c911c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
