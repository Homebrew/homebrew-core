class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.19.1.tar.gz"
  sha256 "da4228ee8ead91e47f04af09709e0de4ce1ac4c126915e12019f37b7947eb570"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "824584b2b02779ffa243b4ca7d0e76cfd0b8aae52511d3cca8b5e97d6acbf254"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c1b6fb6dd2d6d94921228549990b5c09d2abe5b672390d8debb40e375892a7b"
    sha256 cellar: :any_skip_relocation, catalina:      "e2b670cf3ecf9b0934615db1229edd2544d2de8b3fdbb3c6a25de40ca20fb9ee"
    sha256 cellar: :any_skip_relocation, mojave:        "131477fe8ae818fb58ed66081c3563298a2a8f7e24a11e9124fde8f40d105dc2"
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
