class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.2.0",
    :revision => "11ee928ace97cc5f274df13da015f5f84ae3756d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1dd562a766b9085a2b1ed67e99a4951a470a0b969f0d19a4923087752b9c19e" => :catalina
    sha256 "8a71c1e321db86d98c836df2ef23a76fbd7194e54e4ee4c99f2c06def12c9afe" => :mojave
    sha256 "3131e159ded6c5d0504a19d48132ea92157a2440907e99253b8d69b475c173b6" => :high_sierra
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
