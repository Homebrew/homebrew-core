class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.7.0.tar.gz"
  sha256 "c2c4f9161904a2c4fb8e3d2ac8730b8d83759f5e4e44ce293e8e60d8ffae7eef"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e227291ef57cdb472f6eed72ec07b40d22e387eb5cdadc3fed1e4595e2f65dfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289b614d11f5be30833ae352b2b99e597eb45f47a29a30c4987365fc15040a49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f86bc14a4ddf9a628e08754c1cf1cf38db28a2d0482e812ec93ebf06f2aee8f"
    sha256 cellar: :any_skip_relocation, ventura:        "345caa27a81588869193b928c05b75c0eff80fad18145d49e2a93c48305f6d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "33be1634548456c862edcdb50dd46af5e0a915e4e303ac29be3af9b19dac9a07"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e83b1f364f9c22cd561abed9bfaf7adb449f4d4c6c803b8ad7a6e4665dbc2f8"
    sha256 cellar: :any_skip_relocation, catalina:       "b1be0b36fc51ebb6a85e262c339f36bad7774b65d6216072582b100524f33762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cc037600eb7e5cb3ca9828625447cb02b5e2ba00dd6442d6910257727c0a09"
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
      assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end
