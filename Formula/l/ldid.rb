class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  revision 1
  head "git://git.saurik.com/ldid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "84258b91d4f2085704b5d30a0a3cd50d32bebe0ca6e8e3adde999632afd63f4e"
    sha256 cellar: :any,                 arm64_sonoma:   "e3c26343041639b82e88edf54d3af9f579876f800b7aeada94d36c807e441c27"
    sha256 cellar: :any,                 arm64_ventura:  "552c265e507a066ffec6f2476dc9d6057a2ba41537f44f067a50c74ece9429bf"
    sha256 cellar: :any,                 arm64_monterey: "a14aa56dab553afd69f82c3b63a167edb6ae2c3355a8f393e9a6c6c3c05e8432"
    sha256 cellar: :any,                 arm64_big_sur:  "a5f4fffe051e8b54f8c0158ce937802297a76af4dad9140c13ad25a935f4f38d"
    sha256 cellar: :any,                 sonoma:         "a2b4c79cc1cdc1cc91cd7a9474f5edbdd7ed299aad720c65a8e63bbb68d594b0"
    sha256 cellar: :any,                 ventura:        "b6aba3db5dd5aab6835280e0fe777a566cc5eb524290482602ee2b8018145760"
    sha256 cellar: :any,                 monterey:       "2adcc78190f359d7c5485a29cc84c37f5bf3360c39e2cd2cc975a5449bf3db6c"
    sha256 cellar: :any,                 big_sur:        "7373fc777890c829de08c79475c3b2caa55f68c30f97398201ff3dd9c55638ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81c37cabe7538847906e84785f70a8592c5853374424e5866e124dabde43ea2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4519a8fb688fea614c230562638a0d4704e7f1aad8d9372845d0b28cc5281479"
  end

  depends_on "libplist"
  depends_on "openssl@3"
  uses_from_macos "libxml2"

  conflicts_with "ldid-procursus", because: "ldid-proucursus installs a conflicting ldid binary"

  def install
    ENV.append_to_cflags "-I."
    ENV.append "CXXFLAGS", "-std=c++11"
    linker_flags = %w[lookup2.o -lcrypto -lplist-2.0 -lxml2]
    linker_flags += %w[-framework CoreFoundation -framework Security] if OS.mac?

    system "make", "lookup2.o"
    system "make", "ldid", "LDLIBS=#{linker_flags.join(" ")}"

    bin.install "ldid"
    bin.install_symlink "ldid" => "ldid2"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end
