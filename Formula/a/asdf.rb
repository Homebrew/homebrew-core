class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "d7b6e1efcdd62c881c7f4a539ce3a56131d9ddcbcc13e8099ee371545d38706a"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afceac20abb167cd85d4da04e1c89acdd06098f2aa4373deb640729bf7c0012f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afceac20abb167cd85d4da04e1c89acdd06098f2aa4373deb640729bf7c0012f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afceac20abb167cd85d4da04e1c89acdd06098f2aa4373deb640729bf7c0012f"
    sha256 cellar: :any_skip_relocation, sonoma:        "27e44c008fffe03e266a992090543f73f66d189b68579a6e6e1048c969a3e89e"
    sha256 cellar: :any_skip_relocation, ventura:       "27e44c008fffe03e266a992090543f73f66d189b68579a6e6e1048c969a3e89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b804f7d106519efff0a355dcf4c62b8edea0997abef667a1c9b4d5462fd9000"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
