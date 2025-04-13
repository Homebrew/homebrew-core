class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.2.3.tar.gz"
  sha256 "37bfad4ac16f9925e10ced138db88608697af91d8a3949f8ab31b03a109d22d8"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a5dbf84b0d91ebf1fd089f4ce8a0fa635645f77f506e28753ca23b53e388ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ee7cc75153510cef7c5345d23ad4d5906a186b5e06dae68a44e1ed6e987c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7614a306a417cf996094fc6c3f9106695de05a00e48e4d9140f134c05626967f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb9e60d5790a43ab43171d02c108c67bc30f0894a3b3bc78611489e82464bdb"
    sha256 cellar: :any_skip_relocation, ventura:       "2a9b87aaa0588e2f0b40241b034cc53ef578e7ac20ecd454a9c50f19001e00e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9bbaea3d24267a59eb62b851f94a1ae61f1933f9e4fec960b2ba760e1d8ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb9d09c6062e525185482c060ada981f6a51462cea3efc9affb3f252e0889b7"
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
