class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "1111c403d50fc26bee310db8bed4fb7d98a43e88850e2ad47403e8f2e9109860"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a366588cad8733a471b83be8c4ecd16b9d3e46a21981ebb1aaac7e5d975eb218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65cf8b678861bf541c2add288c76ffd8f55449e0d785531ee886335dc548cfed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7d0a074a828667999d5ccbc63a9014c496d8080f5588c5ca97c3f960ffab3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "87eb53c2e0c38484d644a34fa771252fa80a9357b448029a6878e5e8e8db58e7"
    sha256 cellar: :any_skip_relocation, ventura:       "e1fe2f7169aa164531f1184404d8213af4725dd85c9ff5257487c28d260788a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81fe5fb3a19c029f2a4b89a5b8f7446de61c7ef9749630419c4e8c6760f55bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87eaee572a78cf7b00111afa196e6732f05794d83189620bb7be85c4dd217ed"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
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
