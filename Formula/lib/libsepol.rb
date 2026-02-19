class Libsepol < Formula
  desc "SELinux binary policy manipulation library"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.10/libsepol-3.10.tar.gz"
  sha256 "d555586797fa9f38344496d2a7ec1147b6caaf3fcc44c42d8d5173edd7a79a71"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libsepol[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b70e27cd3f015e277465bb7092996febc26b869fce6417315bc00cb5fe33359"
    sha256 cellar: :any,                 arm64_sequoia: "d32a529f97883e5a848de14546b2da0795a1477ea81d87da03a941b13d40ff02"
    sha256 cellar: :any,                 arm64_sonoma:  "19951145b7bd0d84330c2106a52f9a304c39435c172afc7ece9f5a18fda7f46f"
    sha256 cellar: :any,                 sonoma:        "6fb7ec4b1d0a6b41a26f754d0cbf588db433852a9b32b1051fd006560ed9f84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fa5b86884032378074358d534e3d09728bf088b186586cb1ba8f3d29184067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8a7db4cbdafa80b865af18bb9a82349b9049fbe056b6052e1e87dc5dd48fb4"
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
