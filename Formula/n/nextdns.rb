class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "4260824fc20d9d15956c681e6c2025a097f3d350c6dd03dca662f5bbc12bcacc"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d31d85ac7c1b07cd591db0e152b19bb24f0ca19c0c4caee04446a8836bb9115d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f672ae407065c3ef101887a756ddd985f30cb626266204a4790224bd63aec4e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141b5b861acf7888d241c18f83d2636596f7f6f0c68f90ad081c8a9f58e7b18e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf3fbb66344f1ed946878fed8e595a9e8c3f208c25ced6b89c2e3dc510c10d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a58a90339973be0450f4c7edfbf8667f04f19d2212bc999b2f4fe1035d98b7"
    sha256 cellar: :any_skip_relocation, ventura:       "6c73488ba8fdb273712fb7cf9c14d0743228845ac67459fe3a4163083c33e9e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfc718c32615c7d565d27ab62ba9d5472f8304ad7128714e1bd5a5529320193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fc4d299d13dec764c87e745d9eb3a597d5fa47734727fe05bfb9b0ea1e5e62"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
