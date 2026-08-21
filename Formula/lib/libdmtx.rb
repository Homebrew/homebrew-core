class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.net/"
  url "https://github.com/dmtx/libdmtx/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "2394bf1d1d693a5a4ca3cfcc1bb28a4d878bdb831ea9ca8f3d5c995d274bdc39"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d00ba79d2fd03fa854321252a34f897d33324c970bef878a9f86386a7c9700a"
    sha256 cellar: :any,                 arm64_sequoia: "df99e1993d7ed98ff3d11e02eea48940d0eaf29c81f74c45a381832c7e714de0"
    sha256 cellar: :any,                 arm64_sonoma:  "172a87d5ad2bb9e501480bdbb7af5542079729747cd71d2086a8d5025a56e082"
    sha256 cellar: :any,                 arm64_ventura: "b503e7c2c698a420f523d34104850f33ab1f36ddb2f47cc474801ded26bb6d96"
    sha256 cellar: :any,                 sonoma:        "44c8a0c8b7ea70f42368c2633bd4569072dc724f7e38c21cd16ed567a510ce55"
    sha256 cellar: :any,                 ventura:       "e19afbbbf3e0eaed8f35a854f465611e53fcf2865164776a8e7302c9e55a6a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a368525adad2afbfc932f8d332f840b7bd5bafde75da5b8639974236123d73e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8cf01939d9ca1f8c7e6fd7fc6f9c3f243a20893052dbe4e8861eb2b67a7ce0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end
end
