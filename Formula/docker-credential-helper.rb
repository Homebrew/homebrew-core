class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.4.2.tar.gz"
  sha256 "6fb414e71d5352165f43d87e1f711a6638b4ae3b8d4e20a5856a1eaddbd68e36"
  head "https://github.com/docker/docker-credential-helpers.git"

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
