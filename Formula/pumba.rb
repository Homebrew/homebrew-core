class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.0.tar.gz"
  sha256 "e6812f388ff60b8caa0fc380371a1c2bcfb83ce51ece3fae2107b386d5e3678c"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ef40ab374076c364033a847c870402cd9e65705e8c8691eb6e7449d3107b515" => :mojave
    sha256 "1ff46466a29df2952cc32847d3abb901ccbbf3dc45a8a590d7445c365794db35" => :high_sierra
    sha256 "000ab50654d7f8283eafdeb6c9c23b83e28610a8a4d8c840de35d9349f76f520" => :sierra
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
