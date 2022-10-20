class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.4.tar.gz"
  sha256 "b75e3e1f5eba97d4d8a29a476ea4fca4a0f354ceb232028efdb50a19ebdc5afc"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dccb532ff326981dd49debd8e3b3875a20d9a0f5e7be88da898272c89e0b89e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "296407be29c1d9773db476fc3d7af0c59580afcc131726d2e36aa04e4bedc0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "d072dc167e1b32b6a3d8d7b43f3aeac9becb805a1d98447568e88646580510c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f02d6bc06b2c54a5b19507bdd84e5bd88f340411de1febe2d9c93cef7f2875"
    sha256 cellar: :any_skip_relocation, catalina:       "4308db3684441f59a8da6e667995d6dd48969fdd80a51f1438ecad2108e2e3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf0063aa8aaeca2a991a9c36ace7a754079083c62640d6901a6ada11c0b5e71"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    assert_match("Fetch Starting", shell_output("#{bin}/chain-bench scan", 1))

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
