class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/refs/tags/1.20.0.tar.gz"
  sha256 "6321d802103f2a363d3afd9a5ae772de0b4052c84fe6a301ecb576b34e853caa"
  license all_of: [:public_domain, "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/sahlberg/libiscsi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7ed4c8fcbca1477bae283a7263f35afd777bad5c52701fc4613c1a04d2eb97f9"
    sha256 cellar: :any,                 arm64_sonoma:   "b8b214472ef93143e0d926b7b44a4b8f31ab658a4d32c072bd70290185490ab6"
    sha256 cellar: :any,                 arm64_ventura:  "e9cade19921a1d5abfe5b3fcde749ea27ac0169ccefe2ad641cbf335041407db"
    sha256 cellar: :any,                 arm64_monterey: "43ac5887c657c6b82c77fbdef9a4cf0d7619f8aa6d224886bcec9a9441f16695"
    sha256 cellar: :any,                 sonoma:         "740b7f606b002d81ac103bdc370dcd3e8c2fe8d40c4076f82da099cec369cf84"
    sha256 cellar: :any,                 ventura:        "b2ef691dddbb78054d97f690f66d232c5342ab532d675202218ae75c4974acf5"
    sha256 cellar: :any,                 monterey:       "e37fd9ee5cb599780d8b879d39b13c6b8fa123e7d2d259fc958cebadc3600c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f038bc77875a74dcbc70d2db6f0f653ee58b744278833151b0c9a6aea8816dfe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iscsi-ls", "--help"
    system bin/"iscsi-test-cu", "--list"
  end
end
