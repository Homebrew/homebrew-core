class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.8.0.tar.gz"
  sha256 "e04de57ab048f1abee75e9e739514c4f47e6cbb8acacb9d58a6e2892df30dc42"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea473073d77ae8be2329b1c868242b6d5098c46516a6e16669752b8742d56b2" => :mojave
    sha256 "7e48c5089af70b883059a68a4e8be6b3a4a973306067d16983bc1130e23979fc" => :high_sierra
    sha256 "0087bab708bd409d1cd00dcaba1ed40c4ad9e4f11f3b6db275a827fe2ff69011" => :sierra
    sha256 "f791dad7d95875ae19db21305c2d5d3632ebfb7783c837d212a08099d15c4d7a" => :el_capitan
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
