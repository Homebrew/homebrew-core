class DockerCredentialMagic < Formula
  desc "Magic shim for Docker credential helpers"
  homepage "https://github.com/docker-credential-magic/docker-credential-magic"
  url "https://github.com/docker-credential-magic/docker-credential-magic/archive/v0.8.0.tar.gz"
  sha256 "939e12f0d6514c62877ca20cfac78f4556de1353ca4defa34b67df660b5bc1d4"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "mod", "verify"
    system "make", "clean", "vendor", "fetch-helpers", "copy-mappings", "build-magic-embedded"
    system "make", "build-magic"
    system "make", "build-magician"
  end

  test do
    system "#{bin}/docker-credential-magic", "version"
    system "#{bin}/docker-credential-magician", "version"
  end
end
