class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.22.0.tar.gz"
  sha256 "1a27df34f815069c843da18430bca2ae0aa7d3156ea17c5bd4efcfa23014b768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f8ae382e7b63ec1c2b860e1aee2fd4e6d69a5845e1c0597912ebf9356ba58558"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f4984ac3a047e7d0d7dc0a45ddd78096320d66d6642aa8e8685bcdad05fbf8b"
    sha256 cellar: :any_skip_relocation, catalina:      "d8d18d85c19f8537e6905c137f41dbc4afc713486b350a765cdda3bbb9c0c035"
    sha256 cellar: :any_skip_relocation, mojave:        "bb49c7511c9e2eb764834ace4dc32792cab62199ce80381a76673587093ba680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82336212dd3ea4f212cec0b8d0b02019abc750b11c462f526084c9d93d86f97e"
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
