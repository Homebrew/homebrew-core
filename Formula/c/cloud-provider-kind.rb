class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "447ce982e8103934c92a466438cad961a7ca3f817534c3b53c80b12929679b95"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4867a99f4f151a5fc46993d341205c0284b3ca70e29ff5e232a27569f88e5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e855c0f1b8e5f3365803e50fe681f8e19ed9afd6e73edba7bffcb558f26527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ae3dec41af8ae6e0df03af05d71aa9069f5ea8e4ea423c33342cbf25f81674"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eee4fa016c965fefadc4372d845937c6cb17306e0be785c1d6da5189ee95f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b665a78847892a53c75e2fadda0c56cc4921661afef1cdcc303c536c911b298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f92eeade6d3ad52e1eeef18fb0907ed03e19de6ba5ceafaface4803cf1d578"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 1)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Error: please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "failed to detect any supported node provider", status_output
    end
  end
end
