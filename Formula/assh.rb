class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.5.0.tar.gz"
  sha256 "db86e078702711f3ece73b510aca8ab761164202b5e2a0246534b39ecd70de80"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    sha256 "53a8c1dcf2feacd3ee1c2c0c876b236605e2475b3d110430c3fe79e0011d488e" => :sierra
    sha256 "6c476bf520513ccdf0a48956430c602d98bc7490eb2e40d5f6b8a2edbc583061" => :el_capitan
    sha256 "608d04ba760964a018aeb8386feddf3bc18e78708aa1f862f9dd10b41e69f757" => :yosemite
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
