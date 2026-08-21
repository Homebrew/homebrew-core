class Libsepol < Formula
  desc "SELinux binary policy manipulation library"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.11/libsepol-3.11.tar.gz"
  sha256 "79f3d2c88f44b7eb5cf54d9792e03232297e17f97a179163f2750099a00f164d"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libsepol[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5ac2c0ebc7c086598a60b278d4d5fee2a9a4ca777458d56bac01e70cad1a1a6d"
    sha256 cellar: :any, arm64_sequoia: "a20b8bb3630860f9a4f767e2618197a45236e91be7dc215daee8374b55d2102d"
    sha256 cellar: :any, arm64_sonoma:  "f8250e62eea04416711d611a79761f4fd43c6e9df90b1a6a6f8f184b824b5f1b"
    sha256 cellar: :any, sonoma:        "3d1ba0dac3c2aaf2fbdf99de512dfdb75d775debb39f3196e4c100848b5621c1"
    sha256 cellar: :any, arm64_linux:   "1edbd72b4c0b1494cbfc31379f05366bec73eb7100436a59c3f7aad352d25c6a"
    sha256 cellar: :any, x86_64_linux:  "cb6027d6cc54aaf3d30a717c236836957a0439b9398783edd5c42885dabdfe0a"
  end

  depends_on "rpm2cpio" => :test

  uses_from_macos "flex" => :build
  uses_from_macos "cpio" => :test

  on_macos do
    depends_on "coreutils" => :build # for GNU ln
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "SHLIBDIR=#{lib}"
  end

  test do
    resource "homebrew-example-policy" do
      url "https://web.archive.org/web/20250912032601/https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Server/x86_64/os/Packages/s/selinux-policy-targeted-42.8-1.fc44.noarch.rpm"
      sha256 "f551899bec63f9496e4fda49db734a0dbd740c63537d3d4bf285cc5c742b8c2a"
    end

    resource("homebrew-example-policy").stage testpath

    pipe_output("cpio -idm", shell_output("rpm2cpio selinux-policy-targeted-42.8-1.fc44.noarch.rpm"))
    policy = "etc/selinux/targeted/policy/policy.35"
    context = "system_u:object_r:httpd_sys_content_t:s0"
    output = shell_output("#{bin}/chkcon #{policy} #{context}")
    assert_equal "#{context} is valid\n", output
  end
end
