class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v5.1.0.tar.gz"
  sha256 "94d5ba67f5fe4645b7279258b4909f788cae95e689978ffc3fb6aa0db815c795"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1b4f9f6110f526a2b20fbd6b12bf7a00485d32029776a3d83d4153d5d6cf9c9" => :high_sierra
    sha256 "52312145bf6d1b4cab68bcefe9eee73f6b2bcc9b242281f89a0fb74994a6e839" => :sierra
    sha256 "3f018d2ac293505ca38cd00d8f925cae5b999709c170b0fff04fb86298d5f6ba" => :el_capitan
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
