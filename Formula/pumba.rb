class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.5.0.tar.gz"
  sha256 "a748b9c676dcb5504322e653998f3c2faaba4fe27183314a2142ff6421006c40"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "993c462bf123427eaef80fd826fa5ed0310c8d951d9484e9ad7db3c3d9aa4893" => :high_sierra
    sha256 "00cdb8bb8463f3159516e51e0c5d279387e38ad2a8568e5fa7382ee60b32b74c" => :sierra
    sha256 "edbbb8b416547c9ebd9847be7b2eec27b2c9923053485de3504aa513853e2d91" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

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
