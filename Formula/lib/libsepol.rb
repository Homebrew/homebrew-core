class Libsepol < Formula
  desc "SELinux binary policy manipulation library"
  homepage "https://github.com/SELinuxProject/selinux"
  url "https://github.com/SELinuxProject/selinux/releases/download/3.9/libsepol-3.9.tar.gz"
  sha256 "ba630b59e50c5fbf9e9dd45eb3734f373cf78d689d8c10c537114c9bd769fa2e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libsepol[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "839f812ddb1af9b8b0f2457c23f3dd44d2233ed97b780c8b1cd84c30759d113d"
    sha256 cellar: :any,                 arm64_sequoia: "694496f68034e506cc74f711234a738bdc86fe6862c50c4d94056e7992c891e6"
    sha256 cellar: :any,                 arm64_sonoma:  "4acda6a9f6bb64c0054b960c8c89c0b99ae8efb2f4cf826d02945da75d230c0f"
    sha256 cellar: :any,                 sonoma:        "45d2a4183e993e5bff4bba540d7bc371008d9de8677f6bd47fdaa6a30e54a5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702706e29712219dc32584ebd10bca2c2d19bccb71453cd83d500fd7deccf43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3d5fb345b92690961611fcf1894419a137c4b370af1151fe6cd251d20f5d32"
  end

  depends_on "rpm2cpio" => :test

  uses_from_macos "flex" => :build
  uses_from_macos "cpio" => :test

  on_macos do
    depends_on "coreutils" => :build # for GNU ln
  end

  def install
    args = %W[
      PREFIX=#{prefix}
      SHLIBDIR=#{lib}
    ]

    # Submitted to upstream mailing list at https://lore.kernel.org/selinux/20250912132911.63623-1-calebcenter@live.com/T/#u
    if OS.mac?
      args += %w[
        TARGET=libsepol.dylib
        LIBSO=libsepol.$(LIBVERSION).dylib
      ]
    end

    system "make", "install", *args
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
