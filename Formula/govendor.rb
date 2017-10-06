class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file."
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.8.tar.gz"
  sha256 "7e887b84c7a9278473f39ae8a74440ffc17b329aa193e9304d170d458f8785c7"
  revision 1
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77e3219fa70522f32c8b6d8ec30be74ba02964cc193b5b6b8e3a0a84ddaeabd3" => :high_sierra
    sha256 "128c4b938687104b86e21765664ef9426710cfaa3f455a56c02af24aadb0ad51" => :sierra
    sha256 "b5614b2cdd37dec0c5bd2e6b11bba94435127a1d2fba9cdf59451711447aec42" => :el_capitan
    sha256 "cec9a38df63880a8c4cdea079e3f86e4712e32ed7c78c4489fe98f722b056c2e" => :yosemite
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
      assert_predicate testpath/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
