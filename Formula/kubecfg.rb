class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.28.0.tar.gz"
  sha256 "f1dfcf06e3db1825ae5b8bf03fba627d34c08628efc914a0b8bc09d75dd67ac7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50792f708ae1cb2c4bb956eb321540fdeef78b4bbb22bb04619f6dcdfe158a05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bd2f3c9fbdef495aa1fc72285542a1123f494c469c1316c6162107f8af69d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d503ad24c77a3fa0a506d87eefca82bf8116615286b908d412733d9a91ec229"
    sha256 cellar: :any_skip_relocation, ventura:        "fc517acfb6572111b550f667e066419fd20cf4d990bd944275f74a6a49150b08"
    sha256 cellar: :any_skip_relocation, monterey:       "bab16599e3e95aad5bfa1da135bb3d75e8d048a80936f5143e164623afefea78"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9eee9252885bf71944b96e9b7069d3b1810f52f5448159c4646bc802c207249"
    sha256 cellar: :any_skip_relocation, catalina:       "9337ccb6c3a82891e2b5495c4be17c76e9acee0fff680dbba145af672f8c126e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7775f3c48d9b81e97d3f0d96e9294c4a6cbdefffb96e9effbb19ec4deacb04d"
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
