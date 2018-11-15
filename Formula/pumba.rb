class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.1.tar.gz"
  sha256 "b692433dc689ec765a4b822b6024d23143cf391823da7db51b52b012127d32a7"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "920505d0f515ddcaccc1734cb78c21510cfa85e2c8af642829c493921839a673" => :mojave
    sha256 "b76bf17e6ab5e15a4746e6bd1c64e96ce5d5f73bac7b5577dac34440487d1b3c" => :high_sierra
    sha256 "f27ca7901fccf81eeafa3cff20380dc0dfb8c93868f3b3a6ea2c648928356d1f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexei-led/pumba").install buildpath.children

    cd "src/github.com/alexei-led/pumba" do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}", "./cmd"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
