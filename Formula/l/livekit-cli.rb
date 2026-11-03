class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "482a93567afc4b788ece62809b8b2791412cf4e8bdb10657945793a5360d234a"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f7fc923fd83dd17db1383cad37fd0e3f6bdc2edf997712ce74362c3830404c2"
    sha256 cellar: :any, arm64_tahoe:       "c143960e9d0f862d48be473f80f5362cf53107a14b6cc215dd3560b40c7866b3"
    sha256 cellar: :any, arm64_sequoia:     "82bc4b9dee978ad8d8c85731f5ffe3c0072f1674f0c527ca15f521afe3cdd76a"
    sha256 cellar: :any, arm64_linux:       "2e38bf37f1135d468f0df5a0f5b4ee0018187f6b0b90582b4d50d66ae1f8cd07"
    sha256 cellar: :any, x86_64_linux:      "d2608608950bda0998c8bf6981f3f11e5260f00e43c097b8327ce1b7bdc5449d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
    generate_completions_from_executable(bin/"lk", "generate-fish-completion",
                                         shell_parameter_format: :none, shells: [:fish])
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
