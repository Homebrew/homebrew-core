class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.1.tar.gz"
  sha256 "9b36ae15d5bceaaf3496b80413acafa6325c633af3ae211ce10724dfa7046883"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f9af0fc7921719967f8a27eecc6fb809c9806c6bebb218354c301b0943d2b36" => :mojave
    sha256 "fdf91bb6156de8ca87959c94720bbe2538e6a6811b2c6a88442fb086c223ed8b" => :high_sierra
    sha256 "793b4ec299189e18db3b564816fd5dcfcb023a816b5fd8e13c9a1764146265fe" => :sierra
    sha256 "0bd7b22e7f3e0c399a686b56d07caf308ad56f46c9bc718266e998681ef7d7a9" => :el_capitan
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
