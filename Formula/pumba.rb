class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.3.tar.gz"
  sha256 "51338bcfc459a31e481dcb8a6317ea09cc914c185f00f506507d7b331b6c24a9"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad17a6187a071b8de82f9f11cc6b031bed2e21bffc95055d84baf9f193056681" => :mojave
    sha256 "c7804cc4dc62cca20b8c50b975fcfd4424206bbcf8344928ff2fe03a2db078e2" => :high_sierra
    sha256 "1eb0685f20f4cf3d5b84e493c09d045dad41947351ffc7bfa5b4f3fd21c48042" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
