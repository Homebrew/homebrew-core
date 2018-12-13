class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.2.1.tar.gz"
  sha256 "16d76140fee4013df2caf3dfc126ac4648e8872c65e2d1f069c11a5f81fce986"

  bottle do
    cellar :any_skip_relocation
    sha256 "1273e6c792df6df6b7725f56ea0e12b1493d715e24f1bba34ac4109e7acfdbfa" => :mojave
    sha256 "58c6280c68e4f8fe6cbb9d092b2c78263a37a2b8da16329653144fee0232400e" => :high_sierra
    sha256 "45ccbb45260e3e292c1ccde71333341c309984d27e6b964f37f5974ae42af218" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xenolf/lego").install buildpath.children
    cd "src/github.com/xenolf/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
