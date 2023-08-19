class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.8.0.tar.gz"
  sha256 "ca0eb4680ae171828672ea3761a2319d21aeccccbb7c7e67832fed8a91c5af56"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6faa784b7567dbc8767b1a1c9d665b1d5505f31bad34fb88f8471d2e4449931b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86ebc76ce73bd8c6a3ef02d1dbd9f78b015c65720379c9689b3c94313707eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcb1addba2a3c67dac8e03ef5df5ff0f2c8374da76ab8e347cccf06e30604b3c"
    sha256 cellar: :any_skip_relocation, ventura:        "014b0ce7a94ae0d7cb6693c2f9b934ea9204be731a15457c34305ef84e2e3617"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e7ada5c8cd6e20073c15435fd24206a8abf2076962e7b2b4604dd904006135"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bc5da0549e3347a5aea7727c88c0248ec4950da778d703d8bbf3357a5437e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0104e1aba1f9acd7cf0a2961e5982eab2bb6f2f0de77032334ea942e2a5327e3"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-pass"
      bin.install "bin/build/docker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end
