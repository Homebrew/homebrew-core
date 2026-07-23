class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "498740a30c3a3300cf5de0b051b0e7b3a58fd6052960249f7f8c361e44da44d3"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c115300757a0c287e522932b176d47a18e2362bca7a873d32ca3c17d1b705fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58b6e3d4533e0b4ee2057514060406c89f53bd414e8105f7f42a8134d73ec1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc1fcaaea72365981a64169a12afdbbd7a8988aea0a82a5346397c14e540b04"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc8eb89ede8db606d71fa9fae41918ca9db7a40fa9b8f53163153eca10756ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb9c958447054835814ea066abc65a1f5f02c236b70294c706c4569ad3c8eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1bccc632857a7ec7b3413d27f98e19a4d5ecad46d2a90a6e58202ec61c07b9"
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
