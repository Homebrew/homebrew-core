class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "eb46fd70743049384a1b3ea8b07fa9c80db10811bc0bc64f0ba7e52d6c9d60bf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f9bdd0ed71fd796e096e1244c8c4052b295a57b52e5f384c3b6503c69be242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469f768c0473c1b69a10e2642e3020d1f21624589d30874e7bef153a2f74deea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566990448ff046022f76e62605c011ab0e4f6a8dce87d2d9c16a5ba242c6cbfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb3e80d0945d2e946f42f2e212403056262a2042221afd61b36fb729be1a0fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61225960961f9b954b1d73ff8cf5c5054b2d94b2267863f7f81aada5bd8b2a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403fc295aba889aa20f6234998d7949be052d6f1b12efc0d3d5450fb8ff982ad"
  end

  depends_on "go" => :build

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/ipfs/kubo/pull/11124
  patch do
    url "https://github.com/ipfs/kubo/commit/ecf967de3a0ac32c0e2c4f2391518b64741376df.patch?full_index=1"
    sha256 "2ed099b25219f9fde686461e684ff8fbe26fb8ab66b2e6cb213975e84e82dee1"
  end

  def install
    ldflags = "-s -w -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
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
