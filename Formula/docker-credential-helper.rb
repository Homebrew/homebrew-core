class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.5.0.tar.gz"
  sha256 "3e1b9d270d48c730706277735efdf0ab704130fcfbee7eea8a0642f5cdba6b08"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba8ed3e3ef6b633aa2980cd37376e13aeb732550d0e53b618bd03e5d68894d70" => :sierra
    sha256 "c1162fb0846ada1307f1b53160aa8ee9c3223578f1e248829001ce0c033c7753" => :el_capitan
    sha256 "38e33081722df0b7d0c220dfed7c490ae047dcb193fc87c88c08fac09e724866" => :yosemite
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
    end
  end

  test do
    # A more complex test isn't possible as this tool operates using the macOS
    # user keychain (incompatible with CI).
    run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
    assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
  end
end
