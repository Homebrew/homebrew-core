class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "6cb45cdd1e7f964fb15bc260f55238d90eb365d1d3d4cb7f41418637a9316a6d"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b95477e4ef5163a38e72ca7b622c5b3f5f2cb5eb38b7c99b8950f16e55e936e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0a53237392b5a24e0727d8c45a041210cc745b61e09a530ad637a4741ecc46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c869867e03018a03b4a7dcd8a68a85ad24c05ee5cc739f8631534865393dbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "da785d8c64ad263cccb3378927b3bf4f1e059f17e95407a0fc5eb31c77da3510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b796438e486677e81ecc9cb60ad572ee4ba24c21bd0f9d81579b0d961345a3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009a3b5b8130a1e8de00518ccf96ba57b1445a710308dd41aeffd283e6d14308"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
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
