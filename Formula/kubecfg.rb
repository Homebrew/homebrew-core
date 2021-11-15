class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.22.0.tar.gz"
  sha256 "1a27df34f815069c843da18430bca2ae0aa7d3156ea17c5bd4efcfa23014b768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e3fbd55a385cc925ae06ec43a53a30f762dbabed092daea8d786be73e9fdbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21411d14046d3ae8b82ec5c8466342475abff1e37255597f7dc50cd586880b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b5976370b1321d3a20f464fb82113107cbad6e5bc18bb12283b0cb79bf7f05"
    sha256 cellar: :any_skip_relocation, big_sur:        "620aee419a6dfe5306278342e8c0e1376bc0fc8b912afe3f464c780648c23bcb"
    sha256 cellar: :any_skip_relocation, catalina:       "ff815c17f8d8cfe562b1b4fb77d3dc116b4a865bdf7447e6fcd71e993fd1de30"
    sha256 cellar: :any_skip_relocation, mojave:         "11d6c8bb802cdd4db846606d0987b1e5994b0657ee2b74706adb02fd59d643d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba6a990ba822bddf09a6fec189ea6780c4d2f246c1e12046b4ce3e1cba29532"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/bitnami/kubecfg").install buildpath.children

    cd "src/github.com/bitnami/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Dir["examples/*"], "testdata/kubecfg_test.jsonnet"
      prefix.install_metafiles
    end

    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "bash")
    (bash_completion/"kubecfg").write output
    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
