class Chgems < Formula
  desc "Chroot for Ruby gems"
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha256 "515d1bfebb5d5183a41a502884e329fd4c8ddccb14ba8a6548a1f8912013f3dd"
  head "https://github.com/postmodern/chgems.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae71d51be9dea4a7109bcf94073a772038ae50f32cd0eec51179aa554029e01" => :catalina
    sha256 "9b24233632189a803f6e65fcd408bf8220b25ad225fda970a141eb0f7bad4d8c" => :mojave
    sha256 "a9913aa39c5901bc434ce9774d5ccf3e618fa20784a709f7185bc3e26430b367" => :high_sierra
    sha256 "01e2e0335391df51b5fb2003e79d4994a48b4515077904b4e924062a0bf79b3c" => :sierra
    sha256 "395b45c3493721bccfc7fdefa2d81ec61b7f07f8cfd799eac5f1e96011a618f3" => :el_capitan
    sha256 "aac706b654c0e5a617bfa9dab9310334d874d561f2eca10a16778a3b49804545" => :yosemite
    sha256 "d3e7aba5d1fb3da9f66a1e5fd3149c6eec3afb37286ade3e40f235bdbafc8d78" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chgems . gem env")
    assert_match "rubygems.org", output
  end
end
