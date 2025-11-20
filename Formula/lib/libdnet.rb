class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/ofalk/libdnet"
  url "https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-1.18.0.tar.gz"
  sha256 "a4a82275c7d83b85b1daac6ebac9461352731922161f1dcdcccd46c318f583c9"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/^libdnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8425273e5c8aa534be258fb18ba66bf0cb5cc012e2f051b9e8a68126da827b3f"
    sha256 cellar: :any,                 arm64_sequoia:  "e135b6343bf2e3a75c50e48663806ac62e315fd4cb8502e5e277bbf9b6e9f31a"
    sha256 cellar: :any,                 arm64_sonoma:   "d35b638124bc8708333c6d2db7958d11a29cdb4da95492586ce24b387b8d0e9b"
    sha256 cellar: :any,                 arm64_ventura:  "e00bca472fb8213147b83b87fd4df39acd20a50c0d35814f1d8ae1b50b0070d2"
    sha256 cellar: :any,                 arm64_monterey: "8ffb26e94d885f4091d9c3b93628e21dc795a12e53069b880cb69e93b0f2e47d"
    sha256 cellar: :any,                 sonoma:         "92dfd382f45ba91995439a36df8289d9e16e7c27b1557be332c5eaf7b1626fbe"
    sha256 cellar: :any,                 ventura:        "110beea72752872b45e6533cb1ecb27cadf330f1912de6e42fd65d8a45afb584"
    sha256 cellar: :any,                 monterey:       "339dc34fbcb96bfcad077e02d7ee58b3c3ace1281688338d1b728705b4523bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a3388d28e073fe0bf7484176c63fb93b845b0afc4966ac2e63844fe9fc2dc6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cde1b26c6ac0ae9caf126bc85ece887d50cfd7e9aa32c6a734b56da7dafa720b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--mandir=#{man}", "--disable-check", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dnet-config", "--version"
  end
end
