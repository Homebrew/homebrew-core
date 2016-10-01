class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "http://ok-b.org"
  url "https://github.com/crufter/borg/archive/v0.0.1.zip"
  version "0.0.1"
  sha256 "78242fc87fac5b03b821972a7271ab2fbaa0e7cb7758c1a00dbb85a2329692d6"

  depends_on "go" => :build

  def install
    system "go", "build", "main.go"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
