class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.3.4/micro-1.3.4-src.tar.gz"
  sha256 "d74c13a83196b9e62a4c62463115577ad20912ae48d3fac5226ebf33f7724ae2"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "a3b143db5d98ce39cefa8033898061a3373024e94a067a14cb6ae7721fd9a4b9" => :high_sierra
    sha256 "542e4d8547b8c254641a36e1f36e62bbe21a95be88bbc57b90a1331bbdfd9e3d" => :sierra
    sha256 "200e3a70ca69c2b00becf4719e4834b5a73a5ba98c58bbcda33a6a27e814432d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
