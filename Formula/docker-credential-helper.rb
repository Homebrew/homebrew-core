class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.5.2.tar.gz"
  sha256 "aa334cbadf67d61fcdc116ec9ed787bf3ac6eac330a9baf1fef8581bff37ad10"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "749cb69f3bc3e3408958239aeec8c835ea48d698f3f419056dfc0a83ec346337" => :sierra
    sha256 "a8bad7b9d819ded847dededfbfdf5b15d09a318e03af93d8b0b2020149a71686" => :el_capitan
    sha256 "5ee75917c226031b3afc9fa4925c1289ab9bad8078844a74e8d632eebf1b965f" => :yosemite
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
