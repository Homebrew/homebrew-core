class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.0.tar.gz"
  sha256 "e93ceda73c74dc98ae87ad7cda102a8e9eee5d784369fdecb75a9dca0ee06fc4"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7dc135490fdf1e9e78c5b5647c57e22a0f2b141c0b06ac339f145c5db34ea6e" => :catalina
    sha256 "517b7b3d541c18d10c025c191a1c3adebb031c75dbbef164f5eca70fde8dde09" => :mojave
    sha256 "ba810198f2efceffed1f6ce9f1f1ee5106d95b377e41db5ed5acefc9bbc348d7" => :high_sierra
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
