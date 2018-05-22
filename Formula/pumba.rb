class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.5.0.tar.gz"
  sha256 "a748b9c676dcb5504322e653998f3c2faaba4fe27183314a2142ff6421006c40"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b96d76833d5c97d9426dbf631c4a2d3bfc3ba38485734f7f45c04bf48bece66e" => :high_sierra
    sha256 "b7f832d56f5a96c84fb43ec07a34ec969b3f1385d224a6f11d809972cf386ea8" => :sierra
    sha256 "1d68a0d4f7498e04c7b0b911a3cb2938b227555c7825948812ee824b64f430cf" => :el_capitan
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
