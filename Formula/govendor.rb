class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file."
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.5.tar.gz"
  sha256 "ac08ce539e0159efa37d98e9317c88fa90d9da5054a7ae6a16edde3f8c570742"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "386a211790e025dea16d45d0731098bed13cc75a77aa0671515896acd4bc4ca1" => :sierra
    sha256 "9ebc07d73bb652cd3f317590f6fd80390c9ebaa7782feeb91b2db862f4690cd0" => :el_capitan
    sha256 "071d01a95afb054d27b457d905ceb653e66c2a4a843b57e238b35d94424d5ae0" => :yosemite
    sha256 "42836a9f50859d81cdec06d96ec63775936d6175c9f024f5d9d74d7bc92e1812" => :mavericks
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
