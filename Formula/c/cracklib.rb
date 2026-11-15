class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.10.4/cracklib-2.10.4.tar.bz2"
  sha256 "4f2d151a2930ab2644def5f9e0e4dad7446ccbd3f2dd41960e91398d93c3129e"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "338032be69343873244d35917f59d3b473e3e69250067f5443b399e3bbf267c0"
    sha256 arm64_tahoe:       "2acc254c0266961551117cd05fb21668aa629ef2598e55b8968f4f452e811f58"
    sha256 arm64_sequoia:     "975f55605589226ccb62a8d6d4b204f54d0ca186314a6c125365c778c72be9da"
    sha256 arm64_linux:       "eddea1c7ade1c56b95b704f4bbe8feb45a2090abdfe4cc76de04969d350b1002"
    sha256 x86_64_linux:      "9c73178ee4504c9c3e3d7abb8a046dac67a8fb6b6aee2b9ac3c9473e587c1642"
  end

  head do
    url "https://github.com/cracklib/cracklib.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.10.4/cracklib-words-2.10.4.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

  def install
    buildpath.install (buildpath/"src").children if build.head?
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words",
                          *std_configure_args
    system "make", "install"

    share.install resource("cracklib-words")
  end

  post_install_steps do
    mkdir_p "cracklib", base: :var
    copy "cracklib-words-*", "cracklib/cracklib-words", source_base: :share, target_base: :var, source_glob: true
    run "cracklib-packer", base: :bin, stdin_path: "{{var}}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output(bin/"cracklib-check", "password", 0)
  end
end
