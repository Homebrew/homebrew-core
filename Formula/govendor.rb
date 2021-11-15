class Govendor < Formula
  desc "Tool for vendoring Go dependencies"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  license "BSD-3-Clause"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "037aa26c2ac7ad0d1fef83fbf0001e9c6812adb0cc35b26a7ee2ca4c18c3cbcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dfce4585d00e1429cbc2f2f6f25d8e5623f5b5689220918b3dca99ca5e0bccd"
    sha256 cellar: :any_skip_relocation, monterey:       "b281b7fe76751ad3a79605a3fc17457710e7693145f151dab3e999152758158a"
    sha256 cellar: :any_skip_relocation, big_sur:        "479d963acb5e5d0446e223291e301581b55390c80b0e5263ad2a216b0a3acffa"
    sha256 cellar: :any_skip_relocation, catalina:       "85a344d1c8a2488bd4303b2b2bb4deb4d902bb88e2004160588b4c863d664fd0"
    sha256 cellar: :any_skip_relocation, mojave:         "28492791ec9b8c58e472a7276c9b86450112ef642e2aa10d025eb623e0921f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24497503629e520a1fe718029ab520b05c012677df065c9fd104afe4d898b8b8"
  end

  deprecate! date: "2020-03-02", because: :repo_archived

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", *std_go_args
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert_predicate Pathname.pwd/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
