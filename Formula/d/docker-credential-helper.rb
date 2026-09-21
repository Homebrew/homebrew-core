class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "155207a534d52b2182bb140e532a434d2cc970bd523863d3c5b21472ec9400d6"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4fcb0c6ef7cf83a04eccaf2a0bfe33937e5b1ba498d07a4f2c9103b961a5473"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1f2b9df2f877b82cc94eb108e0c571fb5c15d25634d87a5f41f55c565ecdc49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1eb6df2deb246569aa8da54330d1f539411f8264f11221237716c243ef2f3c0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8a3c8d4e28230bff49b7eac0d8a846237eeb4114a5a17071ed07cbc2d9c356fe"
    sha256 cellar: :any_skip_relocation, sonoma:            "ca94062370907762a924ed68326fae59904e487127e717c12911234fcac9fd9c"
    sha256 cellar: :any,                 arm64_linux:       "ad283b7ad070c990dc53302d0bb647efabce85e83b6172dfd13f3934ea9d0977"
    sha256 cellar: :any,                 x86_64_linux:      "981759826b7020ab3638bd4d945bf85c7d3c65dd1e30da1e650bc540239700f9"
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
