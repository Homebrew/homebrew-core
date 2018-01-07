class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.8.tar.gz"
  sha256 "a73bd347f0d0f452be183e365492fb8bb86954b3cd837c9dfe256926bf7feb5b"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7b83cf2ebbaa2431692dff379a6847aa9035537f8ab5809ba4b724d7bdc408b" => :high_sierra
    sha256 "dbb234b88eb380412693ab3cbb6af17a02332cef0792115e105cd6cf082468e1" => :sierra
    sha256 "00fbd50456eff0ef1af172402f79863b1ce968136edcb961e38a520e171d4195" => :el_capitan
    sha256 "77c15338932c82b878d738d79a227054c63cbb32c428e9c85c43a13c91436152" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    cd "src/github.com/cortesi/devd" do
      system "go", "build", "-o", bin/"devd", ".../cmd/devd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/devd #{testpath}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on http://devd.io", io.read
  end
end
