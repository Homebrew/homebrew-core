class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.9.0.tar.gz"
  sha256 "0469b7e34a3df49659e9ec8b5d3e311a85b02dd91b5e6180a8084385ce08e734"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8668cd6f8b2a5b259ce16fa9791620a2c868be5b054e1e8f9825db96b059d655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156d210b52fb47d7ab3aa50e1eab293c8514af6ad50e0f7f94835b3c39ff67bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fa37308c14214013be261966d49affecf11ec850c5b36595e0b8562ce911df"
    sha256 cellar: :any_skip_relocation, sonoma:        "140ec7994e5e7c68b94734bc1f5fc574edec101571ece00617dbd863241330ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd23adfd4c5068b094b6ff9d7b3f7cb408691d50ea8434d6c627eea3ee9d3e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae2953f3295a41721a40db05e4965b4d7aa82233da3c2045a0904677310afde"
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
