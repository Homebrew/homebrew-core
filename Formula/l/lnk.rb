class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://github.com/yarlson/lnk/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "2cbc8f994b7888d2d384a1ed34e1fd73477e1c73b9a05f638d2ad940c6c458ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6134fec36469699ab98492d4e906763b8c5bdd04de45a3aafaab9e95240f10a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6134fec36469699ab98492d4e906763b8c5bdd04de45a3aafaab9e95240f10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6134fec36469699ab98492d4e906763b8c5bdd04de45a3aafaab9e95240f10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c56661811939a7085152b699c93933d441613894e633f97b8db8f2a786458c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76fb5ae306ac2a5eb4cdaa236124e0a98a0d1a28daa7549a33fbb273085c23b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad77754376bce86e224807383beecd027c467f410e278db17e5383ff385a91a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lnk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end
