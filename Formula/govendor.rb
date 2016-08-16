class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file."
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.4.tar.gz"
  sha256 "39dbf5a72617a9688f9dd82db044bd0bd0908c42dfb15e4629a5e381d078f988"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b538021eae35eabc09d5660454a9f838344d18a77ce32b0b378ad5074429a8" => :el_capitan
    sha256 "a0e647d88f7a1ac1e030acb2ebf05641ba3f874c5d8f03d4ba1bed3611f4d7a1" => :yosemite
    sha256 "d6e56e0aff8ac0e2201c1be1d86d8fbe87087dad196777aaf7baf10174bce23d" => :mavericks
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
