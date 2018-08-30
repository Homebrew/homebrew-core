class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.5.0.tar.gz"
  sha256 "a748b9c676dcb5504322e653998f3c2faaba4fe27183314a2142ff6421006c40"
  revision 1
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b511140484e0ce3b12b1243e2a36802a428e020bce8dbee788e67e32d87724a" => :mojave
    sha256 "f7647f9eeb7ea8e108bb5c1d5c323a14c2941787c9bf9ccbd659f7483bfd0416" => :high_sierra
    sha256 "fdb484dc0b44a259651e787915e6dc7d430bbf394d01b26dedc365aab911125a" => :sierra
    sha256 "00c7dad3c0df254440852882ecdc7f6329756b5178fb91d871d68e200a5594f7" => :el_capitan
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
