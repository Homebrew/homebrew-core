class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "068bcc02cfaa5a8b22107763b81b8c7904113d9bbbf022cb0db3d3931539469b"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dc8a0b85c2bcc0f6a773de2cfdc3d28a83aa971956ad11dcffe6aff5d473ce8b"
    sha256 cellar: :any, arm64_sequoia: "05c20ea203d6a57e2897106d7e758c0ba1d3a9a392cc1efb8ec3fc50de845d9c"
    sha256 cellar: :any, arm64_sonoma:  "af2724b5a50954c5c9005cd52e031810845701ed67b1de4b03111562fa09e0d7"
    sha256 cellar: :any, sonoma:        "88d9299c171e1f639d30cc957ee0788813a787a63c3579b85bb60ceb6abaaaf9"
    sha256 cellar: :any, arm64_linux:   "9c6118fed94dbfc60e31c4b8aea8a061e17120d1f270e943b531f7fc90b68f7b"
    sha256 cellar: :any, x86_64_linux:  "438a6c0019e05180907b3198eb3524a352679a98fdcbd5b7ef0abbea3eee9431"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
