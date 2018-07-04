class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.8.0.tar.gz"
  sha256 "e04de57ab048f1abee75e9e739514c4f47e6cbb8acacb9d58a6e2892df30dc42"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8806717c2c661b8460f208030f2902c91ad24972fcfc337e62f94032c9df96fa" => :high_sierra
    sha256 "8858022552599fa0af8807b6bdb760c2011884f904f46a3015efc7bedcbecda7" => :sierra
    sha256 "319f943c77bfd0fd1b6ecebd0bc052e5d11f28d4ae9f6d33ad4f2ccf823c3c2e" => :el_capitan
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
