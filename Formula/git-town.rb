class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/Originate/git-town/archive/v7.3.0.tar.gz"
  sha256 "dcfb61266f2f1fcbc609a52a97d3975ac9bc8860dce90fc98a76f5b1b0bd2142"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b0264cc230c3b3ccc7c45ddc933b6e295edb6ffb3211472da78d1677aa220b2" => :catalina
    sha256 "69cebc1178ee59ff060e306577396c760320e285e7fcbe3ae2367bea5a90da10" => :mojave
    sha256 "0e30581afbe2b9ef24fbb0f9ab655d4e8ab0590e0870cf197fa61d9012bc0a51" => :high_sierra
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
