class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.10.tar.gz"
  sha256 "ebe49ecf9b2efa54b871dce8ec6e979c17e9c05789344fd7d55cba646b91fc26"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cdc333e5f32f12a90de41a9e8138f7392d46d57d774a6b8d6d0c09ab5384ca2" => :high_sierra
    sha256 "a8509afe7e26096b794abd0f313b72c57b9b6b0255efdaa581983da909eabce0" => :sierra
    sha256 "2316e3a32abcbe3bb18d5d4957bd4c90402de4dae8a39696e092875ce5861a25" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
