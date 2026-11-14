class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "b5bdcd9fe7539cbb4feb90aaf734e76c1232cd9ec5f0c976ad549657f53d7048"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e10dba403edee43b5d503060f486bac64e025eaa5818a934f629ffc702becade"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27219ec92bc2ee7f9e34e22da3bb7a9efe58b6169fa5102bfd2fc10f7f0912ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9316607c2830d78d0cc905d2b6790399e72c6e3b2093418b14bdc6bafabdbf94"
    sha256 cellar: :any,                 arm64_linux:       "d31607278819b9009ecd289d41084332b0e536eb52de069450be8d03101ab688"
    sha256 cellar: :any,                 x86_64_linux:      "55dafb1f5c682ba930452b94b1de4b617fcdd93394675c911ed39a3f71c42325"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  deny_network_access!

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
