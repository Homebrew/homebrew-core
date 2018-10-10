class Mole < Formula
  desc "App to create ssh tunnels"
  homepage "https://davrodpin.github.io/mole/"
  url "https://github.com/davrodpin/mole/archive/v0.1.0.tar.gz"
  sha256 "0e9d1cdd87069672a037bf82cde08a9e5d7fedfcb4b3f3093996fe2862892c46"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davrodpin/mole"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"mole", "-ldflags", "-X main.version=0.1.0", "github.com/davrodpin/mole/cmd/mole"
    end
  end

  test do
    assert_match "mole 0.1.0", shell_output("#{bin}/mole -version 2>&1", 2)
  end
end
