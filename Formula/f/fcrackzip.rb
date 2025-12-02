class Fcrackzip < Formula
  desc "Zip password cracker"
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://oldhome.schmorp.de/marc/data/"
    regex(/href=.*?fcrackzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7c9ec0de20570467b787bfe40641aad62b1c0426f8d8441491d169f255daeac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e8664e8c1bc24e41f3d6c16b32eec831c057d13c191245d0d9d726709a23cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "700f97b777acb4ab39338dc9b973e5ab40ffee93835841df970a6a392a17e6b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f647bed7b093952f1bb75429f8f7f00105d0468c7d6b5648db46d8b1ea39c190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46183b85780286b34ec981a6f694271bcb62270238c94eafd02bbf0cbeb6beae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "294092e8601910f3a9120838024621a5604c00bec67cc8fb8e759a8ae2ced914"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b3a83a7678897109e42f39b45cbb151d1f31451d317f89d9c8118be09142aed"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc4f365ee4ffbe7a4491417f1e1da010482b8cbb7659394e6d7e045d86308df"
    sha256 cellar: :any_skip_relocation, monterey:       "c56dbffcc544f7261854bbab1090fc6e4e629661c2db97fbde54c8aedff53421"
    sha256 cellar: :any_skip_relocation, big_sur:        "162a84d06c9ce84300bbbe52feadc1c189de2a7f2dbd5667ca13647c941883a6"
    sha256 cellar: :any_skip_relocation, catalina:       "a460811d270c7f0c5f0bb3960e8ebfeef6d36b822b3ecd7f4448871e3a4e86b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "28f8759404a4879fb9309a4ebc52f204bc646668050819b0e89cb4808f189a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5280f9da3eb29640b3201d9f461a44eb473749110de00e7f36d0632033af66"
  end

  uses_from_macos "zip" => :test

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    # Avoid conflict with `unzip` on Linux and shadowing `/usr/bin/zipinfo` on macOS
    bin.install bin/"zipinfo" => "fcrackzipinfo"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_match "possible pw found: a ()",
                 shell_output("#{bin}/fcrackzip -c a -l 1 secret.zip").strip
  end
end
