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
    rebuild 1
    sha256 arm64_sonoma:   "4cc3fcf34d2fdfb2595cd689475d5337267edd8273b2aee87b875e8bbb729017"
    sha256 arm64_ventura:  "82da2e81fdeedfb9a71f1740ff7bfef4641ccce5f31d51fa6d1ca7fdd576f6ef"
    sha256 arm64_monterey: "4bccbd52d70bbdffc767cf12cfe177bf32002504a300de3d52e91ec8d4d19691"
    sha256 arm64_big_sur:  "3441957c8cd6257a3f4d6cda745aaf22d461a9688408e81cebf538b6f5131663"
    sha256 sonoma:         "e5cdbd5549c1b835b881f67de28cd54ef1fe2f9c6d3147fe9b3577c8a7c88c41"
    sha256 ventura:        "503d1df42838b5d921ab6994410ff2e37b6d3717944fee0440e331f867c8e978"
    sha256 monterey:       "0ace1b1a1ce24edde854033c8bae3c4b3d42379f569f374d9f43b56856f90eae"
    sha256 big_sur:        "7ee4f489b10109d93d69757ffc0cb8b8538e7b391d549d9d133400d39433c22c"
    sha256 x86_64_linux:   "2c1c1fa912ee63f865d0f61c11188f50d1d600e2c8af616175db78c9f51c154a"
  end

  depends_on "pkg-config" => :build
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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/50a00afbf4549fbc0ffd3855c884f7d045cf4f93/john-jumbo/john_jumbo_m1.diff"
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
