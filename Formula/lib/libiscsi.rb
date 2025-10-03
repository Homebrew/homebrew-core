class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/refs/tags/1.20.3.tar.gz"
  sha256 "212f6e1fd8e7ddb4b02208aafc6de600f6f330f40359babeefdd83b0c79d47a1"
  license all_of: [:public_domain, "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/sahlberg/libiscsi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "228ad58b2cfd83ee90f023e8eb33a905b2fd142121ac57ed7cebd4eab871aad2"
    sha256 cellar: :any,                 arm64_sequoia: "e64e00ae751658e12a5ca6338aa6567bb8c7dfa2cb2fe6ab763b4db200a05d70"
    sha256 cellar: :any,                 arm64_sonoma:  "bf4eaa90fe0f76a8745022d1bdcf8105bd6d885332c9081e169c31b223263e54"
    sha256 cellar: :any,                 arm64_ventura: "59724f7813b1c91b9aaf0371f354b595815efe6668a0caed0447bab60989ad4f"
    sha256 cellar: :any,                 sonoma:        "e05be47eac3f6c387f663509646de8afb2483dea007288c5ce10e56e345ba93f"
    sha256 cellar: :any,                 ventura:       "a37fc43c5293c3ff6149c5ef67fcbd4dfeaea876c234aa78616a59ebe8fce8ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e891819a67fc0053fed82690c58fcb76e72e67313bdd06ff11efd445546e28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ba286756eb043dbf79162eb0f4dc7c1f7b495d921ae7f92b7550cae1923b85"
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
