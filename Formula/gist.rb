class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v6.0.0.tar.gz"
  sha256 "ddfb33c039f8825506830448a658aa22685fc0c25dbe6d0240490982c4721812"
  license "MIT"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d756e91ae99001381dda127f1315af4363cb158e323d83c72f466a5ff7c3e36" => :catalina
    sha256 "af69b6fdaf48f811b2eb1789febe49677d74375da1e4b118b7753ff783f6ce0c" => :mojave
    sha256 "28f8947a2912459cc79536eed7cbc2af958c9282f31990741f2fd0f32fffa70a" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end
