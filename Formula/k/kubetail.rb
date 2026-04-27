class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.15.0.tar.gz"
  sha256 "497e063d82c4869620aa1d64d98cbae933f17708aeedc646a7d0af303d887408"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33417f735c75af652a31b0f340c5cb8c14bc691625ef666e2bcc0c96c5709415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d423d49427b00bde3b02d9c26851ee6218a21e1301ad804abef363c8abad38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a6779bdbd57f3c7140c8b6f309318895099e06264ea13137c5544888163fb6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b70448e2118f0856e838010a8f5caa69a28ae64750ba72c8a9963185587a1cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1501943c0e99844b9969dd69ade3b35b602fca1e62e4b2d6e4b22bee6e60f2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da37132fd3bcd11ab8cf1c5c806d985767bbfafaa2af75bc38cfd3bf187ac34c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
