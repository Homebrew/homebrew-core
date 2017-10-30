class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.0.tar.gz"
  sha256 "7d8cdb67c89dece68e96dce11eab9d03c1d798296d3f3601eec4589b24664e7a"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a55283cbd0afea4e7241c7df92917e87e5367fa9bd518bfadca186f3af8fb0dc" => :high_sierra
    sha256 "4296ea20d1b107c874b6ef6cdf116812c2ffe0eee3546cce168ac5d6b1008557" => :sierra
    sha256 "e004af49ee34fca476c7d9da5ce94fa2f551dbc71fd8fd04d54079703cfbfe15" => :el_capitan
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
