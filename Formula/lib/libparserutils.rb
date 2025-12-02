class Libparserutils < Formula
  desc "Library for building efficient parsers"
  homepage "https://www.netsurf-browser.org/projects/libparserutils/"
  url "https://download.netsurf-browser.org/libs/releases/libparserutils-0.2.5-src.tar.gz"
  sha256 "317ed5c718f17927b5721974bae5de32c3fd6d055db131ad31b4312a032ed139"
  license "MIT"
  head "git://git.netsurf-browser.org/libparserutils.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libparserutils[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f611219c6ad2fa78766ef8c18c4518dedb5f4c271266107cdac37b35100e8a48"
    sha256 cellar: :any,                 arm64_sequoia: "e35b156576ddb9a5048e030e4bade56807a40b535d424c2d80fdbd9a322b761b"
    sha256 cellar: :any,                 arm64_sonoma:  "05df8ce204b79a682be32434c7e6a6e917cff35e1960ee23de39984722878f24"
    sha256 cellar: :any,                 arm64_ventura: "6399bff8eeb1132f74e99f92c4795152ad7cc247039e90e7b56bcee7789506ca"
    sha256 cellar: :any,                 sonoma:        "24f00f6da2bc5e10f716aee6e32847f42dcacd22babda850c2cd654c05181c7f"
    sha256 cellar: :any,                 ventura:       "03f0248e3f07e65085701e82621d7a12807560f60a040111c07d867b14d1ddd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ad8bbb44e2b6f06027e1117d02dced9c41c8961bc1a40aeefa8dd7c778a486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f36934cb62bb14686eb7383c94055e3e965295aad1c1338357940527eab90e3"
  end

  depends_on "netsurf-buildsystem" => :build

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
    system "make", "install", "COMPONENT_TYPE=lib-static", *args

    pkgshare.install "test"
    (pkgshare/"test/utils").install "src/utils/utils.h"
  end

  test do
    system ENV.cc, pkgshare/"test/cscodec-utf8.c", "-I#{include}", "-L#{lib}", "-lparserutils", "-o", "cscodec-utf8"
    output = shell_output("#{testpath}/cscodec-utf8 #{pkgshare}/test/data/cscodec-utf8/UTF-8-test.txt")
    assert_match "PASS", output
  end
end
