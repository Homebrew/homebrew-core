class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file."
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.3.tar.gz"
  sha256 "7d7a032355ee4117822150db72a9db745d9a147a2e32972e58a65fe7545444f2"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d300d21f2c60d27b583cbd0ff60b3d4f31e9d1831cf09ba4ea07fd6fed1429d5" => :el_capitan
    sha256 "882e1cf9816240820cf95a5954ee2c980a21d6c445b4b986329b375b715ef9cc" => :yosemite
    sha256 "ade3e446c9270fcb24532d007f23f999e872caff9e33744b5e532506c683f1a7" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", "-o", bin/"govendor"
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert File.exist?("vendor"), "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
