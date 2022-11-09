class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.0",
      revision: "dfcb509a6970af69eaadc6526035c5874108b709"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "912724ff67f0d3ef407130f617f0da4862ca1e1d9fbf7f9d4bfc12d58ab6b674"
    sha256 cellar: :any,                 arm64_monterey: "692ba392f269cbc2858e397c89679f9f6d309af4bdc417ad071187afbe9a5dcd"
    sha256 cellar: :any,                 arm64_big_sur:  "095d6a7e049df3d64f0a95c9ee452b8949dc85160003ee832134a6b7d6dfea0d"
    sha256 cellar: :any,                 monterey:       "bdb805768ab3b77afd7006647a7f4e94fae35172bcbf0ec44a9af9fa880a858a"
    sha256 cellar: :any,                 big_sur:        "1c6382af273f5fed22d8e702beea8157805a57cb07a90b72a3fabec382b1502d"
    sha256 cellar: :any,                 catalina:       "f84a05c6032b7f518b12fe7b704ded0efaef7650ec831412ba134fb3c938730f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a295754a9c781875a9bcf1d030aeae30372c63e1cd765d8d6a85ee6eeac78772"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.gitMajor=#{version.major}
      -X github.com/kubesphere/kubekey/version.gitMinor=#{version.minor}
      -X github.com/kubesphere/kubekey/version.gitVersion=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
      -X github.com/kubesphere/kubekey/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
