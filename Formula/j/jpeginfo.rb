class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.7.1.tar.gz"
  sha256 "274f6be23fd089bd9e8715b67643a66ca2f63a503028bdea3e571228d50b669e"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpeginfo.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?jpeginfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "64d7d1095c95f1ea0e1c0a44b8921e4bfb3696dd47e842c4d403ba4ce8fda097"
    sha256 cellar: :any,                 arm64_sequoia:  "4f5080a068fc3c4e0dbd1f4a1797a633ed8c28e50ab57eecf33b2ee70eb464ae"
    sha256 cellar: :any,                 arm64_sonoma:   "d2ea4f763ff7c44c860bcc04fb737e0a5e258faf6931775349542160ee034e55"
    sha256 cellar: :any,                 arm64_ventura:  "37e8663841268bae70369793b49e98ab351b9213c4e80577042d17e9e45df308"
    sha256 cellar: :any,                 arm64_monterey: "428ba50fee1f9a5a20af595fc15de9482f27c5d81321caf6c96abb7b627757b8"
    sha256 cellar: :any,                 sonoma:         "16807913afe7a5d80b2d64e9f4bdba35ce5a7b8165f14253c3cd176fa977e982"
    sha256 cellar: :any,                 ventura:        "e247c0e359e49aa543b37db1ded9799d2372e03e3c02e5db2462ff01d210e552"
    sha256 cellar: :any,                 monterey:       "92c32a4cffe40740ce0a5ba86a7fe8f521c7230b8d41d6fa0a260afbf00c46d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "671ef654c483d5e351547a8d551a48ba36a66e726fe7ffbeffdc19ac6504142f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7634d933e1769a53a9efe1e9ac4398512efda30266ec24db06bace7f36f95a3c"
  end

  depends_on "autoconf" => :build
  depends_on "jpeg-turbo"

  def install
    ENV.deparallelize

    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoconf", "--force"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"jpeginfo", "--help"
  end
end
