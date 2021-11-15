class Chgems < Formula
  desc "Chroot for Ruby gems"
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha256 "515d1bfebb5d5183a41a502884e329fd4c8ddccb14ba8a6548a1f8912013f3dd"
  license "MIT"
  head "https://github.com/postmodern/chgems.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b94e71d982d3356babc2f034e4ba50cda5b8aee6c289d3d614d6419d17a08c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f8b93d560718a526d4ee4c307168a2d15cbb824cdabd626974466acf4f6e80e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b94e71d982d3356babc2f034e4ba50cda5b8aee6c289d3d614d6419d17a08c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2edf2d389e94beb9bcda4214420badeec9c3d00f9c74618113891508a9246726"
    sha256 cellar: :any_skip_relocation, catalina:       "aae71d51be9dea4a7109bcf94073a772038ae50f32cd0eec51179aa554029e01"
    sha256 cellar: :any_skip_relocation, mojave:         "9b24233632189a803f6e65fcd408bf8220b25ad225fda970a141eb0f7bad4d8c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a9913aa39c5901bc434ce9774d5ccf3e618fa20784a709f7185bc3e26430b367"
    sha256 cellar: :any_skip_relocation, sierra:         "01e2e0335391df51b5fb2003e79d4994a48b4515077904b4e924062a0bf79b3c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "395b45c3493721bccfc7fdefa2d81ec61b7f07f8cfd799eac5f1e96011a618f3"
    sha256 cellar: :any_skip_relocation, yosemite:       "aac706b654c0e5a617bfa9dab9310334d874d561f2eca10a16778a3b49804545"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chgems . gem env")
    assert_match "rubygems.org", output
  end
end
