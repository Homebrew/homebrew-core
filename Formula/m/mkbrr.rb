class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "5ccc5bb71cd785de289491737bf9d61490188b58fe1e1bae859a15433430b48e"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "develop"

  bottle do
    manifest_sha256 "92a966c1001baf683b2f3371a1696bf0cf8a16f6fdc87cf5cc490506b8fe05dc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "421323ebf14d1869cb04ba8c01a72773905bc48d600b3307f1232d11952b3919"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "421323ebf14d1869cb04ba8c01a72773905bc48d600b3307f1232d11952b3919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "421323ebf14d1869cb04ba8c01a72773905bc48d600b3307f1232d11952b3919"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "564fbe1d4b832dd7096b44cc1ebe76e6b9e0ee22cb26ea74d3beda9b0561bfe0"
    sha256 cellar: :any,                 x86_64_linux:      "59f12127c6f50e63091bf7d1396a1f6ffa824d818446472020ccf2400381d441"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
