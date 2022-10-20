class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.27.0.tar.gz"
  sha256 "4fed9a09ee12fa2452becb9b64278444f99093d3044bc417aaa92ab3b5851d81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8c599b530ea6e392ffad32eae315c4df77d4ab8697c2fd09f5837ba402c131a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf055bec7533a856a84e1fd79db5347f900619ebfb380318feb95dd7ac40346b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d9fd238db1efba13fea37740dccfd2478ea3d497a69c2622fb7113bb020e89f"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b474b024727b5e9cf8d235606597c5d2908d6cd2881b17e597cea3f92c7168"
    sha256 cellar: :any_skip_relocation, catalina:       "1fc431a6f7a97621ce9c00f10f4b7885f7def50175f25dabbe52993fd235fec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3e5b71623d46c82aaf1e2b6203c643efc432617fa2406fe3722580999d4d8d"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/kubecfg/kubecfg").install buildpath.children

    cd "src/github.com/kubecfg/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Pathname("examples").children
      pkgshare.install Pathname("testdata").children
      prefix.install_metafiles
    end

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell", shells: [:bash, :zsh])
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
