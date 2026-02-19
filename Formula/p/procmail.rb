class Procmail < Formula
  desc "Autonomous mail processor"
  homepage "https://github.com/BuGlessRB/procmail"
  url "https://github.com/BuGlessRB/procmail/archive/refs/tags/v3.24.tar.gz"
  sha256 "514ea433339783e95df9321e794771e4887b9823ac55fdb2469702cf69bd3989"
  license any_of: ["GPL-2.0-or-later", "Artistic-1.0-Perl"]
  version_scheme 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1bfc16b0cf3a29c2782b0bd30bbf11b04f0586a01a6ebeac2aad63fbb9a8c16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2dee1f884a35fe10236bd86b12bd6bc507aa720f764be04e75fdc042c75fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9daf01dcf08b8b98d376cc6a99f1e8404db58f51ee2d62305ec604ddbcf3d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09fcc2d016f1f67c3f69caa887411eab4e0b44c0c1e465841604bf6210522e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d075ce7ac129209d21b5eeb25f2c5431f7921bb42d36140913855c27ee1aa53d"
    sha256 cellar: :any_skip_relocation, ventura:       "f3b010bf2fb93f2dea465f19d898358e75f0fce1bfca7e31cb6298b607426f8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f7f578ac20ba0e61130aaf67f1e0357cae7419791754ed9163a90c758a005c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09534e911a38143ef58d749661b6359585308a1f42cb842b425f3fa6f803ff70"
  end

  # Apply open PR to fix build on modern Clang/GCC rather than disabling errors.
  # Same patch used by Fedora, Gentoo, MacPorts and NixOS.
  # PR ref: https://github.com/BuGlessRB/procmail/pull/7
  patch do
    url "https://github.com/BuGlessRB/procmail/commit/8cfd570fd14c8fb9983859767ab1851bfd064b64.patch?full_index=1"
    sha256 "2258b13da244b8ffbd242bc2a7e1e8c6129ab2aed4126e3394287bcafc1018e1"
  end

  def install
    # avoid issue from case-insensitive filesystem
    mv "INSTALL", "INSTALL.txt" if OS.mac?

    system "make", "install", "BASENAME=#{prefix}", "MANDIR=#{man}", "LOCKINGTEST=1"
  end

  test do
    path = testpath/"test.mail"
    path.write <<~EOS
      From alice@example.net Tue Sep 15 15:33:41 2015
      Date: Tue, 15 Sep 2015 15:33:41 +0200
      From: Alice <alice@example.net>
      To: Bob <bob@example.net>
      Subject: Test

      please ignore
    EOS
    assert_match "Subject: Test", shell_output("#{bin}/formail -X 'Subject' < #{path}")
    assert_match "please ignore", shell_output("#{bin}/formail -I '' < #{path}")
  end
end
