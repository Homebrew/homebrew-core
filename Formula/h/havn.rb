class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f0934b924ced72782baa0cdb0396b369b949264b5b6ed6b12df0ecb5ad26787"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db0beb0811cb8fc100033db12f7910e068e85cf225d45e3d1c453f5d7ea51419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17277db9bc357c8b1f2cab63642876e17b59ede4d18263f9f225473a10b91e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0584384e2e19e002f63ce737bc64b90a28c23f2e6ea7163c64d3df1b8a5377cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "94eee713868a3a64f1f7c5caa7ffb6890e4a653ca5789e221f4ec7104ef67394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8fa2ce1e0e08ebb1f292d74244b6d0158d8a260835366150a9712d45130c8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03795e0bd584de97bce01f54d4ce22864cf40fdf8f6beceae2c71e7547e9db7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
