class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "fbe44f56a608379bfba890aa989db9f2477b0da02baa94e9294805e8305b6721"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7035b555e99e9a2d2bf7b36db251c9042c77acac3164fe79c3b3f04d3e8d5409"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7035b555e99e9a2d2bf7b36db251c9042c77acac3164fe79c3b3f04d3e8d5409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7035b555e99e9a2d2bf7b36db251c9042c77acac3164fe79c3b3f04d3e8d5409"
    sha256 cellar: :any_skip_relocation, sonoma:         "2211f8fd37019528da2b4ab2ce042a34a64820139f92ab483857f426b1a8d721"
    sha256 cellar: :any_skip_relocation, ventura:        "2211f8fd37019528da2b4ab2ce042a34a64820139f92ab483857f426b1a8d721"
    sha256 cellar: :any_skip_relocation, monterey:       "2211f8fd37019528da2b4ab2ce042a34a64820139f92ab483857f426b1a8d721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3588ed5f2ebdb32557afc3e054a7d586827aa613fef426e93ee8f34666f961e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end

  service do
    run_args = [opt_bin/"edgevpn"]

    if OS.mac?
      used_utuns = `ifconfig | grep -E '^utun' | cut -d: -f1`.split("\n")
      next_free_utun = used_utuns.map { |x| x.match(/utun(\d+)/)[1].to_i }.max.to_i + 1

      run_args += ["--interface", "utun#{next_free_utun}"]
    end

    run run_args
    require_root true
    keep_alive true
  end
end
