class Govendor < Formula
  desc "Tool for vendoring Go dependencies"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  license "BSD-3-Clause"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "479d963acb5e5d0446e223291e301581b55390c80b0e5263ad2a216b0a3acffa" => :big_sur
    sha256 "85a344d1c8a2488bd4303b2b2bb4deb4d902bb88e2004160588b4c863d664fd0" => :catalina
    sha256 "28492791ec9b8c58e472a7276c9b86450112ef642e2aa10d025eb623e0921f40" => :mojave
  end

  deprecate! date: "2020-11-15", because: :repo_archived

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath

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
