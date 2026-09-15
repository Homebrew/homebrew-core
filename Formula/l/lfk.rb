class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.14.tar.gz"
  sha256 "8dd840720d04f9ce43f297330397346aea09b437b46175a1ef4859415ccce1b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4020f8c21a0b39ac03ef362d13f2fb297bdc2ba3add42081d555369bc766d63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2f121f6ac60f82e585bf9fbbfc3c9f7c0341781b6797c8f4d76a0a4c9961fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82d59253db38998155f02fd2444030f1c87758cfc8d91828c5319f557938bf92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7d75d4365722513e3050ec7edd09765a854b69aeabef85b4a5328312b83b2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a5017567040bf021194218d79467d64a440fd548a986500f4e1b555bf745d8f9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
