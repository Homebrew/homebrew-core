class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "7f2e5ed5e9c9c483288a227692b70abe283bdf78b0abc36d0846704bb6d82c94"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32a13f2b19eb7a0dcaeac61ed12db0638da0d9bfb8b6686f747af2368d9f5bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6023c533e0f446cf94116653a1ada8b2ed0905b2edf0b081879860307afb8182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27de93b602f77896c309f74ddbe18addd05bac428532445d9bf09be391e0c94"
    sha256 cellar: :any_skip_relocation, sonoma:        "5146e8cd9f6ecb5aa634e21a21c560a476d0dfd2ba4c236ba2623d8de945d2ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0972123cf7aaddc65f33ecee5b23312b017f2621832f909ab3c700c2fe384d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7aa12483804175950f7a8bea8d0c0a18a402b05a07ea1c1b9d2893e8d2293be"
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
