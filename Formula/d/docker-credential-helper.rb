class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "28ee1cb4be24f88b9fe76bfd99b7d51af7af618085850c98cf473e520f67c736"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14bd94d9d32f9d5f25079a927ad02f72d5159e48f9f34135f9bc4f5079000df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4ed1dcd6a8f7ce21b88bc290f8a93c6c9154f65a45ac3d54766013da5f096da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b73481561d41ab78cdea464e1e0003a9597548dd583062ae42961efe9aee2cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "933fb05d3666968e099a098bde4050a6ff8ed7169eec323b7d682b10a174196f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660cfb25bc61c35814ae2b574e55055511b5ded229352ac4c964285889bc0a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bac9866125abbf43bdc1c071b34d14c3bf790d7703738429d780adcb9c785f2f"
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
