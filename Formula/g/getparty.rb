class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "d907ce3679d7ab1d79657d0066cbfd5d3a963ee0a6a3fa2b48a1766c52daa2a4"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8a738a875501fe17023af8dfa6452add13f86fe6fadf9ca6bdbd01f397c4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8a738a875501fe17023af8dfa6452add13f86fe6fadf9ca6bdbd01f397c4d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e8a738a875501fe17023af8dfa6452add13f86fe6fadf9ca6bdbd01f397c4d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a313f111332a6317c0e269292372b82cf575c4d58b70c1216664c0e2ef2769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70bdae3987a2a997178b166b937dfc1075307178a164b94fe5ace6e39313114f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60e0469aa69f675344d6ee6843ef5ea2548ee836cc03531060593b658563e8e"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
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
