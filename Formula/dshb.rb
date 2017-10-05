class Dshb < Formula
  desc "macOS system monitor in Swift"
  homepage "https://github.com/beltex/dshb"
  url "https://github.com/beltex/dshb/releases/download/v0.2.0/dshb-0.2.0-source.zip"
  sha256 "b2d512e743d2973ae4cddfead2c5b251c45e5f5d64baff0955bee88e94035c33"

  bottle do
    cellar :any_skip_relocation
    sha256 "491d5a425463fb4f328503f91cfe6e28a0785fdbf8ec7a323a366bab54e4158c" => :el_capitan_or_later
    sha256 "94085328f6ef593ca0d00923fabfe43586c1c4b51eaf555ce9c7db9d7db1f486" => :yosemite
  end

  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "release"
    bin.install "bin/dshb"
    man1.install "docs/dshb.1"
  end

  test do
    pipe_output("#{bin}/dshb", "q", 0)
  end
end
