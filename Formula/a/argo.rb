class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.2",
      revision: "cf605b548f1b0137836dde2032517707ba87c6ae"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "762cc5d87e5d67c1107e0a3c9852f48d2a2c8157ca03c9dbac65404705fc934f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5c4f03ed75f6fc060f4529ecfa5e4faaa6d6f4749c3bafc9c578d014762c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57bf3fe79025e9cc73ebc04941e700f52f84ee44a11e59661c98a467c120eb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d474e6b8c21447cfc0f2893a4fa74673d9c861fe5da7b533bc2fadf8140ac1db"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a4bd2de0872f8abad4c2f6c86a1df04cc4815068bb7e316c0e1d3f331d32e9"
    sha256 cellar: :any_skip_relocation, ventura:       "918071d75fa1726db865aa221bf52e8c187644cd4e5a33c5ca76f728ecbf9bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "416321063386a9f0a7204e2605f76ad6cf2b76a05f672e90941513d99765b2a3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo", "-j1"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
