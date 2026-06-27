class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "7954c8bcb271021a7b3a8a992a5eb2828af3b5668659582112f2dd672c5242ba"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c3baf4fad995b8be4e951f7ef654d6e60bff6756e7c048d0d2d936e8e260eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f49797296707edc78d3ca7d152016a99767849288605bd9f52a9f4763106ab4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf81d34a381b3d9a79465d2187c5a66c3bb2a0fd3df86b0ea85df0ca4d27116b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cebff49822e5c7e7e668ac296196c8a2c3942fd915845e9d73c00750134297a8"
    sha256 cellar: :any,                 arm64_linux:   "ec12662a1ab5e3f770de3074125c9d575ac6c6e81c4b425fe9584394322bfa27"
    sha256 cellar: :any,                 x86_64_linux:  "ece0f2baea8f0a30d6e8740c355cf1101758bcaf24f88934ba00329e3609dc37"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-secretservice"
    end
    system "make", "pass"
    bin.install "bin/build/docker-credential-pass"
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
    run_output = shell_output("#{bin}/docker-credential-pass list")
    assert_match "{}", run_output
  end
end
