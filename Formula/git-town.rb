class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v5.1.0.tar.gz"
  sha256 "94d5ba67f5fe4645b7279258b4909f788cae95e689978ffc3fb6aa0db815c795"

  bottle do
    cellar :any_skip_relocation
    sha256 "23f027fb8f2a2b51c0f2dfdc1648b23e8c2ba8997d6d0cd53fa15028c883d8ac" => :high_sierra
    sha256 "0f8a1b78156059d5b9a7345643c8a9df78fccef03db5578ba467ebed755dc7bc" => :sierra
    sha256 "990826bb05ed0fc2e821fe41814039e761c2b84a6b0a0deec18b2de778ea6fda" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Originate").mkpath
    ln_sf buildpath, buildpath/"src/github.com/Originate/git-town"
    system "go", "build", "-o", bin/"git-town"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
