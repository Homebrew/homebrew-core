class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4bb66ace71ec560a50ead6157db69950c3e9e9960c54f8f10037530de9d4e93b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b46251801c782169d49b7069725ce6458ff48d64883ec5084f99e48e1bbcc34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafa8d19b9b6e8c5f886473e15243251873c9179dcce5eca890c5250bf121ab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da410fd18e38d986e29d75e34df74a5986991b7851d15ac9ef52d06ca89895b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd75cf3cb9b424584330d8cab3731b7e04f618bb4da584b3064393560b00c12c"
    sha256 cellar: :any_skip_relocation, ventura:        "1ba17f9ec928b0e8b4699c71fe31db3d09c37e2a920da2a5b761d82b5d40659c"
    sha256 cellar: :any_skip_relocation, monterey:       "54240b227bc9ad27dd6065b70e8757d6bbb480fc348afbe9839ac5c8c91d68c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e12bf2c12edce5b181a24b01e544f05b7b898703c04e1c328634922fff4839"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
