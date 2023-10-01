class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.34.0.tar.gz"
  sha256 "0d1cd054debe0b0a6239cc9980d2a88b60ce31caf19cf70547c2af1a2d289c86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2d85e2ebc54a0b61f4de6b5b4e3ea7525778a56779828531ae9f29f3e4a0c30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3876ed78956dfeb9580044904dd4e35a65547112fc626ce8c677f78e139e920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eca2fdb41260eb88ce122358a3683af9e6ebb5183dcca36b7051d90ad6ea9c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "e994d8a271ef14985f23c004651d1c7a93face25ecfb19458416687f3be77b37"
    sha256 cellar: :any_skip_relocation, monterey:       "afd474b64be4b99018e7e60b0f22db1a04b39da642139562e6163127a5f9c37e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d06f9732731479c40bfdf9090862847389e3560c3ae537430138c0e32e380e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9bb09db9bfaec29ecf105aee491c721d489b938bbd9ebb9ba98106dd336846"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
