class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "2208e5942fd456852695de225f7ef5b20c511af9fc928364699fd28d165f99a8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c453647bd157362b7a32aaf94959c343e275245953082a4dd9915f9fca8bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9592f403158a7ed95d831c7c3730de5b38606ac18f3fd8856257167f2b6e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6abdafaef215711254e97f96f6f8d3f3213427ac32777b58858fd1a8931a62f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5d6d42b5eb0cb0a52e19a4e95b6c0876568ef6ac02a2390754a66cfe8a2f90"
    sha256 cellar: :any_skip_relocation, ventura:       "38118c5256a4b647eb09e0253189f65acfe2acb4157d92d5741d5ba5e9262a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2097664a01a62032cf010eb9e6883c3a160e3c7721afaccdc8cf9d687567e24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
