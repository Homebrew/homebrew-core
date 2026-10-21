class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "26fe64555610f1cf521628b957f91e811ea64c47182d4dc19261e3aed5a1bea7"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7288f7bb65c5d0f518b845e063cc2bee9cc52e5584f2fbab1df758281873f7a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c89b0e8feeb67af50636c2f97b0ebd674e4a6b845d57da0df9e7f254c17a2c4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b56bd705ce8f8dc51d32a66bfae498e82e90f5156df51919046e609f75119fc2"
    sha256 cellar: :any,                 arm64_linux:       "db30a9bfcd5b06197b955c68999665c692de1ddf3fb597b3813d5f3218641857"
    sha256 cellar: :any,                 x86_64_linux:      "3ab2960632a400f998b1ba73c3da3a110cf1071d1852fbfe4dc40f7a311de875"
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
