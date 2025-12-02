class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "f30965064b7a8888afd1454a39160ea69023d0eeac6eb7acb783a05cf57c87d6"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b9e711f896a88e06c342de31e24c2700a0880acd24d9dd7d800d31b759478f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9e711f896a88e06c342de31e24c2700a0880acd24d9dd7d800d31b759478f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b9e711f896a88e06c342de31e24c2700a0880acd24d9dd7d800d31b759478f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "79edbdedc30489bfbfddd60c4075ab204b674ef81698fc193fe5eddff6053377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3814ce128281e7c479e790e52ef9d8e40331da5e075e9c4db14291a7c8dd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c707930702422ac791f069da961aa15c5e3d4b3d14fe8799afe402166bfd384"
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
