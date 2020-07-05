class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.4.0.tar.gz"
  sha256 "f9ff00839fde70bc9b5024bae9a51d8b00e0bb309c3542ed65be50bb8a13e6a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b0264cc230c3b3ccc7c45ddc933b6e295edb6ffb3211472da78d1677aa220b2" => :catalina
    sha256 "69cebc1178ee59ff060e306577396c760320e285e7fcbe3ae2367bea5a90da10" => :mojave
    sha256 "0e30581afbe2b9ef24fbb0f9ab655d4e8ab0590e0870cf197fa61d9012bc0a51" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/git-town/git-town/src/cmd.version=v7.4.0 "\
           "-X github.com/git-town/git-town/src/cmd.buildDate=2020/07/05"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
