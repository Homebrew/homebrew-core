class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "8d1cb5f778be6fd941184dec07e2c8255827442638c6311a11a32036902e2090"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90f9832512d1110cfe60c3cb5a41538c5a3546cf5101b102b92a754e9c74af56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f9832512d1110cfe60c3cb5a41538c5a3546cf5101b102b92a754e9c74af56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f9832512d1110cfe60c3cb5a41538c5a3546cf5101b102b92a754e9c74af56"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07ea509718d64cbfd446f26e9b54de4c7a7656f88e8cbaa47a900ccebd57821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ab8af2101954deb91819b8a837b97305bde5ce96a80e2d2f5bfb01374e75a3"
    sha256 cellar: :any,                 x86_64_linux:  "77c95a9b5447d96b01e896157007ee05ff02e270df5a1f86b6ab969f32685bc7"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
