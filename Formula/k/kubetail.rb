class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.7.4.tar.gz"
  sha256 "fd0d4cd66fccccd204302177df90672f5728a91f7e37fc83d6967f7615caf4b4"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b540e2e21e2052e927854b8d87df62506789006e4d346ade6eb2199251b02fdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aca515b77a16cf40e7edece3e17738f33254a1ac8630a8867da60f9ef7db83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "051f6fa590e3db1ac2f9afd0baa042c7c4414170ac6339d13126552f4528bd53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cff8b691f69e1f00489fd55739276f9ab9c78edf06028baa6bf3c64c430c23d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f07421ffae4cb76a01f4452debdfde8dfb7141f3e824f3380fc67f28d70513"
    sha256 cellar: :any_skip_relocation, ventura:       "97d616eac05ca4497214d3b403de3aa04a5770e330864b3e8e55d99132e0c857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267f693584ff9fabb94490f80e697b69bf55933818ed8c441ef6c4f68118e9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73387c48127e6197088f9d2b5d88745862038e35b3c713d9b7b6138150d1424"
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
