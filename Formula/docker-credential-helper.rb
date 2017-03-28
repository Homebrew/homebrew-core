class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.5.0.tar.gz"
  sha256 "3e1b9d270d48c730706277735efdf0ab704130fcfbee7eea8a0642f5cdba6b08"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "828f38190cb50e4c46231ec8702045ba043bd235e01e4394c927af5c107b340b" => :sierra
    sha256 "1802d5eceea5272559401accfe011d9a6f11df89e2686a7b937bf1dbe6f1475d" => :el_capitan
    sha256 "f0397eb7d5f5729c134c775fd8a6087ed470c17826a914e320644811d6bc9fca" => :yosemite
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
