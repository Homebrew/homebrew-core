class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "b668801ca648ecf888687d7aa69d84c3f2c862f31b92076c443fdea77c984c58"
  license "MPL-2.0"
  head "https://github.com/myENA/consul-backinator.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ab0ec7b817355e3a6546b2b0d77026eb3c0bb22c99e7d5c582d8fb9d98b982df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8839abd4d9ee77b2e2378c281bb982e4af742ea32996c592cbd70e39f882a131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dd6cbcb9488966e0c5452941ff2568e991cef265c705f3e20a465bb1346c238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a382c9d7060ffefb09aa0aa62509ab46dddd90f9d65d0248bb6c75003869be3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed17c5c263df3f56c445b9ed9416206802102d3cefbf38ab893f7237c94e622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "579fbf5bed18b1db8efc3d97621580316dc3d2d903fe085be3cd3dbd3ef72930"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b12b3e564f5f6de0d630fa46e944d7a24baf806a4ad5051a2812a68cd7fc4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "409a9b3e6b4b37408200b6613c2d1e2bc1adbe49a83913330d19cbf525fa4841"
    sha256 cellar: :any_skip_relocation, monterey:       "541a6f16a60cca90b1f70c474d46b0a20bd6d9965e3190d60ae653983915c8bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0289e669896c287102e265b0d164021c0eed4d0906d972d4b85df9084dd01a3"
    sha256 cellar: :any_skip_relocation, catalina:       "b984053374292f96bb3b095aa9338f15aa9962be4473f8eaaf64a43598f39c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5f6e773350096ff9841f971fd31552892b987271c04a1a887b39f953cd0d972f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b914861d80658228a91c3946d85609b07a780a9747e0302ebd4be3a5d1ea94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/consul-backinator --version 2>&1").strip

    assert_match "[Error] Failed to backup key data:",
      shell_output("#{bin}/consul-backinator backup 2>&1", 1)
  end
end
