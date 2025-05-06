class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/refs/tags/1.20.2.tar.gz"
  sha256 "2b2a773ea0d3a708c1cafe61bbee780325fb1aafec6477f17d3f403e8732c9bf"
  license all_of: [:public_domain, "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/sahlberg/libiscsi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "356c93d6460c560bde748339a32b9c55da3f12f87456b92ad2b66fa18b97a1ad"
    sha256 cellar: :any,                 arm64_sonoma:  "511dfedb43e4f60a8eecf8c7b4be234b8eefd7562e75e40315fcc26d7bb9845e"
    sha256 cellar: :any,                 arm64_ventura: "4b709afde3dc32d739d185f64219127e075082d95d64c452cbace5168cb72c71"
    sha256 cellar: :any,                 sonoma:        "dee5dab9b9fc7b002b7db84bb077c6d9d79ad9e0aacfb43e454d8ab875d504ef"
    sha256 cellar: :any,                 ventura:       "ce29e9ab144b9576c20f7845fbf7005b5b6f1700179b64ad534cd0af319b4012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62bcd8e86cd4cda4fb79bfde300a0cb3f105caedc6457d5aa8628cc54493332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98648a44c47ae8d3567fc190792913c8de9df491a4c1e0cd67e1a03f5086584f"
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
