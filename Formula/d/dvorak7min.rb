class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "https://web.archive.org/web/dvorak7min.sourcearchive.com/"
  url "https://deb.debian.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  version "1.6.1"
  sha256 "4cdef8e4c8c74c28dacd185d1062bfa752a58447772627aded9ac0c87a3b8797"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f3a4344484d832af72a35d2759a70018fce691d9269a6c4161a7da74bae7fea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1bf4bd048107bae98d33859486f996dcf0a7cf7a9053414c243d060960c3938"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f581243f32da61dd063a2ef9c4e8c2297b4bd556f7905d4a520009a8bf865b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38e077e0ee68158e8b287d8bf9b679378cfb03a496afd2049f9b36e840ba2c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb028aa9707f685095023a20694b713e9adaa2f4ade7adc95b483f54d2775a6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3615a35945e18782b7bef5fd0a677ac3a667a216472dba858a3ee559db63fa3c"
    sha256 cellar: :any_skip_relocation, ventura:        "b4eeacfb1b35f5498fb7f77da6b513109a87a54d686a62a6c221a08aab9a8178"
    sha256 cellar: :any_skip_relocation, monterey:       "cbf598fe212330ed130813b5a7ac1be0f31ea98b7aa3e12559371bdc35217356"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e42924b5dd8704ca4fa6d70b7c966c3956268ebf78ef5fc2022fdee3c1ed82b"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f692d9254375715d1f85af32ce5b7487802597818f2bb969b3cac109d3012a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a3db52bd009b55ad53eb6c23914b8b39d9bc098cc48cc6d175d57da6806db717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88198e60fed089e8dcc4c8bb9fb955428cecd480578fd1a339e177b1c1e748df"
  end

  # source is a copy from debian
  deprecate! date: "2024-05-04", because: :repo_removed
  disable! date: "2025-05-05", because: :repo_removed

  uses_from_macos "ncurses"

  # Apply Debian patch to fix build
  patch do
    on_linux do
      url "https://salsa.debian.org/debian/dvorak7min/-/raw/56019daffd5c0628ef5b8ae200a69ba43263d7d6/debian/patches/debian-changes.patch"
      sha256 "05303478d7006e376325db9d3ea00551acb0e6113e0d7e436f96df8d6f339e2e"
    end
  end

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
