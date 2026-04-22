class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "aa0409f5bc2afcb9b03c567ea3d61b1009f3075cc2e80da938bff4a9c86dda54"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156b597b775477acd7adf1a545951543b7d8a955fd0a1ae1d5973295ca98358e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d543223d51a32bffe2edaf4c2493697ac9131b39e01dfffd608ed465445dbee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ecf70e79c5a628893494eacda30c22cdced2c0256c2a38d01112be4947ef37"
    sha256 cellar: :any_skip_relocation, sonoma:        "02196839b6a8695c526d5f0464ba8fd21d903a089df1a0e0693bd28a176ee6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b2632e1266c7513a039cca78284b57dc4e968f870032bffa2c5c0c3f9711cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86380650693999101fc26b49f7c0bc13222245bab7d6759079bb80966b40d246"
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
