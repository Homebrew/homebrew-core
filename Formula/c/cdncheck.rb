class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.39.tar.gz"
  sha256 "5c7e42839be5790ca49b5d3c6e40f41736a8523e5e94859f48d5101b12c0459f"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e2345ba2d5c60cf8176b32745f0d29f979c9178e462774c2ace0cb64801dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd6c0fc6bf81b5d50ffe174eb3ccaae26c61f337d81dd3ebf9782c7a76d6021d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050ee5d6d8e73e82e00fa70e87487758b6a018a2355149046602a8537bb56acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f879f7926d957ae2a84951c33a426a6d09c4ffb2c3bb33d86eafb0b2c44961ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f665ff88e1e9c4cc238e6f03bdb5859ff059360ab44bb634c5a48582abec62f"
    sha256 cellar: :any,                 x86_64_linux:  "429f55a05e5bfcd1655c68ada5938ed341ec366d6bd6d1a43052acb70a938c43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
