class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.10.1.tar.gz"
  sha256 "3d9edae9cc6b270a75f0bc4aa4a83326defe67126f509965bb2150e5530015a2"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42a07f9911a7543836f854111008f7ffb300ac3711e7b5b2d810547f8e7517fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc48134f8861436654332b02d0017f60dc764f3acb15e28c9334787945799ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dab6bb3a675b908aa075f28a7dc0c08ca18101d50488d22813d1159416098f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "191279fcaa3330383eaffe6a8c15ae2c1a0eb916611da905937f3c09447c0d61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66db361f4ff769de7d63fbff81bba5a92b3ed34d21d812b20fab2503dc3633f9"
    sha256 cellar: :any,                 x86_64_linux:  "66baf17f8db0f15d4303d47d4c9868d436e485ccceaa199da5ac935fd8339adc"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars", "--no-module", "--skip-proto"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
