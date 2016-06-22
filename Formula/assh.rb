require "language/go"

class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.3.0.tar.gz"
  sha256 "d2903d3723c8349ec09bc8c7ada1fcb60d835f248d4df1faf5fe6fbadf484f16"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3327d87a59a3b905b88b3c356448acec7af015888c2baac10dac21584342d4db" => :el_capitan
    sha256 "9ebee2d29a5cc75e7406f52a9ec77da25913b688579e345c385820e08a2fb55c" => :yosemite
    sha256 "002eb1502db3837377c08b829096f6ba7b1e6c23d3b314afdef616b293ba04c2" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end
