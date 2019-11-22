class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.2.0",
    :revision => "11ee928ace97cc5f274df13da015f5f84ae3756d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffdee52b3c648683f4fabbcdc56baa0dc9cb20b44ac877155f08a6d627d2cc69" => :catalina
    sha256 "9dea300001bce666a42667cbf8c967bf2c73d0494b072bd147dd99c6b8aa2b2f" => :mojave
    sha256 "506828353d7593b758035b0e3302661c78b75c347b5165829f2ab0ae18224422" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/go-acme/lego"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
          "-o", bin/"lego", "cmd/lego/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
