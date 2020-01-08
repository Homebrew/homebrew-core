class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.3.tar.gz"
  sha256 "441684cf1d2434aa1024aa2f8455e11502c44858e93ea171b19caa656dd2b2e2"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b29ba43b81fd4cbd72defa6c9ed49d730b520555b2d5dd16e35c4da2835896d" => :catalina
    sha256 "a4553f6ca40dd3c012a0ddc910b7ceb4b819ee89d1366613c9205f356f5a2a69" => :mojave
    sha256 "71b6622a61da363350ca6065c5683a7a157b4ec404c8e11f66752ac2f0e09063" => :high_sierra
    sha256 "3810d91647e6385bb9d57da3c800d1107603551285a94643f0d530bb63821a2d" => :sierra
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
