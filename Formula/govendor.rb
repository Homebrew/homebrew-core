class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file."
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.8.tar.gz"
  sha256 "7e887b84c7a9278473f39ae8a74440ffc17b329aa193e9304d170d458f8785c7"
  revision 1
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47607859fcb87a51ac05640433c659a94cf211e533eb6d391075a6c0033498c1" => :sierra
    sha256 "d3be3c95b074b3ff08858854e8124955a26892df928b9fca4e15d342412def28" => :el_capitan
    sha256 "407185a36b0203b208c509404cb81599534c3919ab0a978f199f08623bd88551" => :yosemite
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
