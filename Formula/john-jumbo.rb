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

  bottle do
    sha256 arm64_ventura:  "d619d5c6ad355d0ccf8434bfa9d65d8baad56678c01fc9e0d0674d23663d24d6"
    sha256 arm64_monterey: "87eebf43b7a544bf756affb4519798e3754867bcbcbd946e7616bc99fd0f7d37"
    sha256 arm64_big_sur:  "c1223a9135967ac2aadff6423e381d91b7b0421e03fe5a380543fc7566542eed"
    sha256 ventura:        "3b43e7cef626c15f438936079ac74ff0297d72c09995d63917e6d8c245947d70"
    sha256 monterey:       "30a4feeadf226c792fe1714d2ac01a169b3d6609a046d08db23a2014aef13f50"
    sha256 big_sur:        "f57a158083194a19ed0e52d1098e2bb7f7b6eb36e4bcded2d2b735c36c09f97d"
    sha256 catalina:       "357620f058f892a637262e1c49edb436a2b2159123b66146cd323180d8a3c081"
    sha256 x86_64_linux:   "2831ddaa75b8827bc870d5d229ebbe556c5bd40b5359141bed7384ea358fc0c5"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl@1.1"

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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/50a00afbf4549fbc0ffd3855c884f7d045cf4f93/john-jumbo/john_jumbo_m1.diff"
    sha256 "6658f02056fd6d54231d3fdbf84135b32d47c09345fc07c6f861a1feebd00902"
  end

  def install
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE=1"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_EXEC='\"#{share}/john\"'"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_HOME='\"#{share}/john\"'"

    # Apple's M1 chip has no support for SSE 4.1.
    ENV.append "CFLAGS", "-mno-sse4.1" if Hardware::CPU.intel? && !MacOS.version.requires_sse4?

    ENV["OPENSSL_LIBS"] = "-L#{Formula["openssl@1.1"].opt_lib}"
    ENV["OPENSSL_CFLAGS"] = "-I#{Formula["openssl@1.1"].opt_include}"

    cd "src" do
      system "./configure", "--disable-native-tests"
      system "make", "clean"
      system "make"
    end

    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john.bash"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5 -r | cut -d' ' -f1`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
