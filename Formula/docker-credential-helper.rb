class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.3.tar.gz"
  sha256 "441684cf1d2434aa1024aa2f8455e11502c44858e93ea171b19caa656dd2b2e2"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45857cfeb3a6dae0eab38e6ab95f97d81aed153d8557f056206d34367dad717a" => :mojave
    sha256 "b6d991d3b84792ec89e89a0fdc992667eff802c8d3d166f203b11014ec91592a" => :high_sierra
    sha256 "ea187fef2e07f44c1e58e9f6467e721435340b12a5e8b3ff321bb3a6ab0203e5" => :sierra
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
