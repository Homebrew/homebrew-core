class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/releases/download/v0.43.1/kubo-source.tar.gz"
  sha256 "470f90d551f34ff65b533299e8f55ed3d2f2d062fd15c998ea53d095bac3ed26"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "276665cca5758a0732af9dd0b7c8fd65368ca7149cdb8202ca7ccaac6dc03a77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3dc13fea45be008b77cffb6430caa1152079dc40cd552765157b61f430c1ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1dfded311edc68d3adeebd3046ae7fa9242558b251877cebd860f48025cd669"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95b9da561f65c80605ec4e3c179dc699efee9f5b8d35364bd6481f9051e6a1be"
    sha256 cellar: :any,                 x86_64_linux:      "92aa3bf69d67a1af567a6d74310cf00683b4890b3a3da2ec1971ae7108d65484"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ipfs"), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
