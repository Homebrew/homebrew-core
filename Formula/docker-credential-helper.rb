class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.0.tar.gz"
  sha256 "7d8cdb67c89dece68e96dce11eab9d03c1d798296d3f3601eec4589b24664e7a"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0036db94fc9229787d6f41f47d33a3a603bf7e2fce68bc9915737c4a80c34ef8" => :high_sierra
    sha256 "1fc4138e971461416eecc7f2fa6de5e119c9e6ec62e72f5ad93df44e975356f1" => :sierra
    sha256 "0f62544ffc1b783e13358f7ccc69668db17c2211e787e6d5179ead0234d9a992" => :el_capitan
    sha256 "5bafacd08b548dbaebfbbdce0237d5378f1da8a98daa0f0675a2ed0476022913" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/docker-credential-helpers"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "vet_osx"
      system "make", "osxkeychain"
      bin.install "bin/docker-credential-osxkeychain"
      prefix.install_metafiles
    end
  end

  test do
    # A more complex test isn't possible as this tool operates using the macOS
    # user keychain (incompatible with CI).
    run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
    assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
  end
end
