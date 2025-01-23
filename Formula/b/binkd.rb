class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "https://github.com/pgul/binkd"
  url "https://github.com/pgul/binkd/archive/refs/tags/binkd-1_0_4.tar.gz"
  sha256 "67cc5c254198005e6d7c5c98b1d161ad146615874df4839daa86735aa5e3fa1d"
  license "GPL-2.0-or-later"
  head "https://github.com/pgul/binkd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:binkd[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363282ef02c77db08c0963460807439902cc81ec6bf480f1fb2714fd2f0211f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55fbf747f2e698ebf87a90b001d4bf62f9486012f860b561835a3c45730b4f97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18ee6019972abd32129415ce9545fbb80abf690bfe4aaa6dcd599d3ab9ab17d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7df6b2f5bb3437e91f6c293b63cf7dc28de37b458654d9b925cb0354dd296394"
    sha256 cellar: :any_skip_relocation, ventura:       "1d0c2d8e07da1e49cafed0aa027ea488105b3b8088b69e76d3027d3fdfe70c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99d97e67e7079053da1c408b6064abff7ff447a116e2044e4a39d82ed654bc2"
  end

  uses_from_macos "zlib"

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    inreplace "binkd.conf", "/var/", "#{var}/" if build.stable?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/binkd", "-v"
  end
end
