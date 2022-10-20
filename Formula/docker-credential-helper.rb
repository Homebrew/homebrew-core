class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.4.tar.gz"
  sha256 "b97d27cefb2de7a18079aad31c9aef8e3b8a38313182b73aaf8b83701275ac83"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fbfeca2a0efa2081e97fb1048f4b5236f07e3d23b1e18b04616de0a4678c27b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c33c81c19c588dba521a9cf3c7e9a9e402529a743c44e453be2d5a7de529173"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff0d7d5e31056b8c98f3bedd28cd07b48b59fdd34c600fdf94bdc77100cf1ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3efeacdbbce115d279f6d65dad68eca32afa0844d333a2c56f17ca36bba53f8"
    sha256 cellar: :any_skip_relocation, catalina:       "1739db425f719496aea5493cfd6d24616931a212172aa320f58e28c51c065fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb26b7a359764d1f39562b7266448cd92b3cb167418041bf87ece7eacb27b5df"
  end

  depends_on "go" => :build
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "vet_osx"
      system "make", "osxkeychain"
      bin.install "bin/docker-credential-osxkeychain"
    else
      system "make", "vet_linux"
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/docker-credential-pass"
      bin.install "bin/docker-credential-secretservice"
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
      assert_match "Error from list function in secretservice_linux.c", run_output
    end
  end
end
