class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.5.2.tar.gz"
  sha256 "aa334cbadf67d61fcdc116ec9ed787bf3ac6eac330a9baf1fef8581bff37ad10"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85d6c3b4c3c26cedab3504e4c969c18599a91be3a10c1d23046a5d7ac4f7aa1" => :sierra
    sha256 "124dae0355057c012f8811d72321de9422b82a6cdcb93577cfb8880a782f7226" => :el_capitan
    sha256 "a386f37e68e5b577d831b081d9e08c07588fc4b1ec35b501dd16fe9b22724de9" => :yosemite
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
