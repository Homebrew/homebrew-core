class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/openwall/john.git"
    regex(/^v?(\d+(?:\.\d+)+)-jumbo-\d$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "b70737d5187ee86a9a28ae0a72d8ffb71a045555d633db585066c53f61de7745"
    sha256 arm64_sequoia: "60a5968b96000102a72df069793e756067af2b87d862ce01b9cd1e24bb1a4b05"
    sha256 arm64_sonoma:  "865c20ab8f23bf0c8213cc88014e36bf907f17a9f924d477d4866e8ea0e76e64"
    sha256 arm64_ventura: "f70a5308db1137f69fa0da915a2d4898453db9339467044b224b64df1c9feb53"
    sha256 sonoma:        "9579793b2cc5a9f493d4f45e92c509981dad449817f390df62fad67163656bd1"
    sha256 ventura:       "5a03775927f3e4d2bbb843ba2fb614674f2342143d5e6b0644ceb852e7ad8da7"
    sha256 arm64_linux:   "83af0cd09a6c71fc6b6a424a3346907678d9846c6e625c19148db1ce8dce05d2"
    sha256 x86_64_linux:  "9c218a9de0a672e13bd10012a4b7f6257bb1cb9e4e3c094b8444ade22cefb2d2"
  end

  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  conflicts_with "john", because: "both install the same binaries"

  # Fixed setup `-mno-sse4.1` for some machines.
  # See details for example from here: https://github.com/openwall/john/pull/4100
  patch do
    url "https://github.com/openwall/john/commit/a537bbca37c1c2452ffcfccea6d2366447ec05c2.patch?full_index=1"
    sha256 "bb6cfff297f1223dd1177a515657b8f1f780c55f790e5b6e6518bb2cb0986b7b"
  end

  # Fixed setup of openssl@1.1 over series of patches
  # See details for example from here: https://github.com/openwall/john/pull/4101
  patch do
    url "https://github.com/openwall/john/commit/4844c79bf43dbdbb6ae3717001173355b3de5517.patch?full_index=1"
    sha256 "8469b8eb1d880365121491d45421d132b634983fdcaf4028df8ae8b9085c98ae"
  end
  patch do
    url "https://github.com/openwall/john/commit/26750d4cff0e650f836974dc3c9c4d446f3f8d0e.patch?full_index=1"
    sha256 "43d259266b6b986a0a3daff484cfb90214ca7f57cd4703175e3ff95d48ddd3e2"
  end
  patch do
    url "https://github.com/openwall/john/commit/f03412b789d905b1a8d50f5f4b76d158b01c81c1.patch?full_index=1"
    sha256 "65a4aacc22f82004e102607c03149395e81c7b6104715e5b90b4bbc016e5e0f7"
  end

  # Upstream M1/ARM64 Support.
  # Combined diff of the following four commits, minus the doc changes
  # that block this formula from using these commits otherwise.
  # https://github.com/openwall/john/commit/d6c87924b85323b82994ce01724d6e458223fd36
  # https://github.com/openwall/john/commit/d531f97180a6e5ae52e21db177727a17a76bd2b4
  # https://github.com/openwall/john/commit/c9825e688d1fb9fdd8942ceb0a6b4457b0f9f9b4
  # https://github.com/openwall/john/commit/716279addd5a0870620fac8a6e944916b2228cc2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/john-jumbo/john_jumbo_m1.diff"
    sha256 "6658f02056fd6d54231d3fdbf84135b32d47c09345fc07c6f861a1feebd00902"
  end

  # Fix alignment compile errors on GCC 11. Remove in the next release
  patch do
    url "https://github.com/openwall/john/commit/8152ac071bce1ebc98fac6bed962e90e9b92d8cf.patch?full_index=1"
    sha256 "efb4e3597c47930d63f51efbf18c409f436ea6bd0012a4290b05135a54d7edd4"
  end

  def install
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE=1"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_EXEC='\"#{share}/john\"'"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_HOME='\"#{share}/john\"'"

    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse4?)
      ENV.append "CFLAGS", "-mno-sse4.1"
    end

    ENV["OPENSSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib}"
    ENV["OPENSSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"

    cd "src" do
      system "./configure", "--disable-native-tests"
      system "make", "clean"
      system "make"
    end

    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5 -r | cut -d' ' -f1`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
