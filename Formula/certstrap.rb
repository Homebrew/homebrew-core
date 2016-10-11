class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git",
    :tag => "v1.0.1",
    :revision => "c66ef6751a6e5a900c6d96cbdd0e3ee9b18792d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "46889a81451253666a9e53824da5bd423141dbfd20a72b7e8aa93fd85775b5b9" => :sierra
    sha256 "5772fab8033d5550b1abac449ba0f41a2cf15ce5ed4de6d85857a8c86accef5a" => :el_capitan
    sha256 "d6cba517c38934484bdd754a3934ceccffb759ca5e87f19ca120a0d00d84ec85" => :yosemite
    sha256 "d0070d92e962492cf582f371b6ec803a1ee9b8ae4a05172b3e06b242155704da" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    system "./build"
    bin.install "bin/certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
