class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "4189d8fe3cec6deecf2f8fe89bfe5734bf786b123907294103eca824ff862800"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c563198b8bd0fe936449afce0be8e4dd2eae2c373a9b0a890cf73dd5180e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c563198b8bd0fe936449afce0be8e4dd2eae2c373a9b0a890cf73dd5180e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c563198b8bd0fe936449afce0be8e4dd2eae2c373a9b0a890cf73dd5180e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7bc4a511d8d1052bdda82448cf782dd8da76ccf66a57fcb59fc586100fdeef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010a425e7e5e58752b48632ea56308c3ac706757538a8391a7db3658ad66ab09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8466b62d7f105d7647bfaceeba4567573b43b715adf54f7df72f83bc0c54d60"
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
