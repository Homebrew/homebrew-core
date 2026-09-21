class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-6.x/giflib-6.1.3.tar.gz"
  sha256 "b65b66b99f0424b93525f987386f22fc5efb9da2bfc92ad4a532249aaffbab0e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/giflib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bdf5a53f053c10c716573cf955e5f50d704d97f9d2dedc781161031744b77849"
    sha256 cellar: :any, arm64_tahoe:       "5bf0850f756c9fe9469d628d1833b0d44db914e44b6b67037e91312c0d0f560d"
    sha256 cellar: :any, arm64_sequoia:     "cfd0ce71b021f10c57fe01270b77703a82c56032afd078a48d7ad48c603ae0de"
    sha256 cellar: :any, arm64_linux:       "298868b541405172596e292ed27ba704239eaaae6d83816e37ae945a47ab141e"
    sha256 cellar: :any, x86_64_linux:      "8e8b91a9a5412978380c43049dd2101939e7b699a6ded7bd18e72a91b34d3e3a"
  end

  deny_network_access!

  def install
    args = ["PREFIX=#{prefix}"]
    # Manually skipping shared libutil due to https://sourceforge.net/p/giflib/bugs/189/.
    # It is currently unused (binaries link to libutil.a) and not installed.
    args << "LIBUTILSO=" if OS.mac?

    system "make", "all", *args
    ENV.deparallelize # avoid parallel mkdir
    system "make", "install", *args
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
