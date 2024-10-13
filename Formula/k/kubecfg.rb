class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "863b8872a848a1938c471e1690efe9f3e59d8be6e4a407504dc1f8c4b9e96e81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b38a32176d56dcc2f0c79382f3283b476bd81d087c79e12096978afe84683a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7058cb919bab4944210d6699b907de011e40274b1b092068453c529ceca4e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a000e2f42efe132d04532db749a35e0bf7efa027e0e1743b4b5c86eeaadcc41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9af259c5cc137b202e12b68dfd63cfc257f3b37a4d1c2af99db3ebfd4cf66f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0775e6e70b9c540f12e42ad181716b666372ce71dfd6243b9be20477dae84e4f"
    sha256 cellar: :any_skip_relocation, ventura:        "4c428fb6513105d868ce2ae68ccd6fc2eb060409e5f7ccec721cba9eb1f60985"
    sha256 cellar: :any_skip_relocation, monterey:       "db3e0fcb93a1fc514f00626e8b0ca5b350ae6ccadae85e0155153c32fe081e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f339d39f1b8c81c4dffaeaa19080b59159269140ef5b7f379ae20514bc09ca22"
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
