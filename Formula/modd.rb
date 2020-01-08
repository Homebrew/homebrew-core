class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc54b5c78bf68af83b2ae7233f5bcaf20295ba803e82aa4a1ccd77e5a9dd9a9f" => :catalina
    sha256 "d1b77821aff14d108379646434442ec9ca4869ec50867083c8e109c35dfb5095" => :mojave
    sha256 "9dab505f6322b00919c69a8b396b25efb04f38341d2113c0681e6d12181b13d0" => :high_sierra
    sha256 "165da808127db6197c4dd7e4b527118baf29aa74747d9c7ae84cad47d1bd8e79" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/cortesi/modd").install buildpath.children
    cd "src/github.com/cortesi/modd" do
      system "go", "install", ".../cmd/modd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/modd")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Error reading config file ./modd.conf", io.read
  end
end
