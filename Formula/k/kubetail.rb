class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.3.3.tar.gz"
  sha256 "11c905d937afb731daaa097923bb62e3c6c3f345a4d4d56da0c1ed9d4ca08299"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eda3b601291aa8eee9b52eceb7a71aadd8740c8ca74d294c3c841e4ba302206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ee50393edf103077306bc6a3a6600f375f2f16c5b95cc68d92689cd6b93519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed03625d08ab060c4a4513c34a85563e1117fe6c2a09098b1167fb979ec70fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "f55cd44fc3688fd43398b79d21a0897a55095be3766cd5c5a203e2506efdcdea"
    sha256 cellar: :any_skip_relocation, ventura:       "3d9679aaddf1b6259ea7acf573771df5a2b8771065eae8c46340ee3551872773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72b37a9386802a1de63873f225ac6733a6e610adfe1e68f40b7b57c8ccc1122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e175d2ffb0ac41bd9ff04e9b55117aea326568b0106ee743f96231751a8652"
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
