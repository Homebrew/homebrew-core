class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  stable do
    url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.2.tar.gz"
    sha256 "55d4a28e05ad7b4691d79cd113d623c8fed5077653e426d5457a6232259f4ad2"

    # CNI: add Homebrew's installation path
    # https://github.com/containerd/nerdctl/pull/4761
    # Merged into main, targeted for v2.3.0.
    patch do
      url "https://github.com/containerd/nerdctl/commit/a1cffd64ccc1ac6c261f10937e3b3fa57ccac90c.patch?full_index=1"
      sha256 "667781729c9225e28fe9ddb2ad32e7b46f2bcfc62b5ef95e5e9b592e0c221414"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ed24b21eaf6d27dede5df48055d2b0a5abd299f95e5ac41f449cab4e491557ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b00bb44232a31a7cedaa6144060f4cd514d4e859837567ae503b3a37f312e7d9"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v#{version.major}/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"
    bin.install Dir["extras/rootless/*"]
    doc.install Dir["docs/*"]

    generate_completions_from_executable(bin/"nerdctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
