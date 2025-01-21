class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.0.9.tar.gz"
  sha256 "0a00298523f8cd1b272373145e7bb3087a7b5f640f42b417bb1a4e52a9eac454"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0dc8d1665765c6ad3d26e3613bb844108fc5d9665cd7476c77c37b52c432cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e4bef4cdae593ae4431508ff1fddb038b7eebcb402ad58fd701503cc18ced2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c16614d79ddede707789703ff4d96a3ad25d5329688672c3477fda57578b7a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b37a7fafb880546856c6075d542b656c3d5ca4cffd1f75c29365bfeaa4547f"
    sha256 cellar: :any_skip_relocation, ventura:       "d56a39729cd3ea671095506b3845163c8be746f3870a4cf696e7da510a367053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a42a3d13750d3de02227cfe24950fbe1010f3b1368ee3f8f12253dc31c2893"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
