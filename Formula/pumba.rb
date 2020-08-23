class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.4.tar.gz"
  sha256 "319a5ec5538022a2cdb8065c489272af474fcbc3f55d194df085b4cf90e22bbe"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "519fdbcf6e8d2c04af9afedef0e43842c284a8044568ca9cf25a3746d25ce36e" => :catalina
    sha256 "ac736b20ac2e438ed3e14dab8307b1daad959688aa29d307a0a979cd48f9c57a" => :mojave
    sha256 "1465a220b1bfa39691c85b967406d960af5fbf55714aafa8df3fb98f2d054b1b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
