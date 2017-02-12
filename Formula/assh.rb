class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.6.0.tar.gz"
  sha256 "0b425b74ccbb3e440fe65489c6fbcf0000c865577dc516b8136008423ef89613"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d39ddd78d465c8d8d308404fff1b9ad8c2771bab0aa6ae5483239fe99ac4906" => :sierra
    sha256 "55085dda63a41d04cfaf01a0eddc2b1be9e0036eeeaae663bad7d7c335b5f1ab" => :el_capitan
    sha256 "415d43b13abcb120b73acb604a683bb56cc29e3c3d353c21d60c9266821c0456" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end
