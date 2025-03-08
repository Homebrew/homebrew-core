class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "bdad4f712244f11dc64890db2f915166306bb4b040149f4497c31f33c7a87327"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd1300d81482b2caafb3bf72f4c92a7ffb7729101fad076ae6cf4cf40f3d301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaaffe49a54c96fc6b6ad778e9fde495d49f4cca60f49343aa7736b87594d0b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268897c05a0ceef58f40bb067c4ae8fe7bd2da45826edda4996ce87fd7918a0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "267746edfe93981ddd4f761bd5e6ec2516fa3910120d5c6f167fdb04aae10081"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7e5511f55c528bd31f897a4b15b35271fc61e793d25e1bd0f5346a9b560c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b56edbcfe9483e55d2aee15d7f4cca6a7484709b2118e346b7da76746d4df7"
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
