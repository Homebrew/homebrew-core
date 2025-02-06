class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.9.tar.xz"
  sha256 "b8dca8d4aa6e39593402e8c366c9dd741904ecf5ce0dba89d0cef3c0d7166813"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a48f8ed5198ca77f4b92d753fd0dd71ef4c6f9c77d9ffdf4062083a72a2368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a48f8ed5198ca77f4b92d753fd0dd71ef4c6f9c77d9ffdf4062083a72a2368"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80a48f8ed5198ca77f4b92d753fd0dd71ef4c6f9c77d9ffdf4062083a72a2368"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63a2f857530b7430485e50720fcdf11a05b20635e1e6a5d03968ad6a4c274e7"
    sha256 cellar: :any_skip_relocation, ventura:       "c63a2f857530b7430485e50720fcdf11a05b20635e1e6a5d03968ad6a4c274e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc56b68786d8bff2276896d497027197bf77e443fbe1d59ee567cf0cfc25b8c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
