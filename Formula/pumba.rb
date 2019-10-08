class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.5.tar.gz"
  sha256 "d3f19bba5520ec2b26554b807e31596a1cf16da60cf34d945399cf45a369300d"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5639041fbd2e4653fe922f419332e28255fb7d32ec7f76c63839324738cfffb4" => :catalina
    sha256 "257ef1308a0e73183d0aba22aee88c5e1cf7dc8ab8f673b556e63c43652a03bc" => :mojave
    sha256 "c6c4c6181cd79cbb52c0e52b4b952163427f66125d03028b40ac38a497896613" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/alexei-led/pumba"
    src.install buildpath.children
    src.cd do
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
