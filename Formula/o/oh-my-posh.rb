class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.5.0.tar.gz"
  sha256 "4f053e6b9ec624bcc404a33d20e8a373ae7d3a049bce313b170132dd75201c3a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1620276c3065ca70d42f8bd2845ca10cd8f9fce243e8efb8a1bd63d45abd5a44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414669f82a1a2678322cc4599ca586cf721f5a0393f49b369b1baa144f127172"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b333679c8f22feaa35005f4a37e88ae05c58946fa034e1a3a6250d94a60709f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0fdef790fff908c5e493c6df07a87b5a213950fe7113d704afe49ef3422235c"
    sha256 cellar: :any_skip_relocation, ventura:       "69d38ee097d12f4b4d1d84cb4fda73af022aab7230ac68291389c4a6282cc483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec8d491e3ad135a1013e6b4ddea0d91378d98fb5283ccfbf8a48f42317b4e9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
