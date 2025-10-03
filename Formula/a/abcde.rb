class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.3.tar.gz"
  sha256 "046cd0bba78dd4bbdcbcf82fe625865c60df35a005482de13a6699c5a3b83124"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.einval.com/git/abcde.git", branch: "master"

  livecheck do
    url "https://abcde.einval.com/download/"
    regex(/href=.*?abcde[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "580cb0f7c45b342dbdfac94e4fe3a2dc6db572409e212d963b22fba20a002423"
    sha256 cellar: :any,                 arm64_sequoia:  "48c8a99c5cf28e44096fe46c62f5dc826a90282769b895fb50807cca0f5383b0"
    sha256 cellar: :any,                 arm64_sonoma:   "5e728aa1561686b5cfb5fe14f2fec3f4a106a7403a9ccaee4c9fd3c1eca530e1"
    sha256 cellar: :any,                 arm64_ventura:  "dedb7cfd40ab62f591ee97a8da975fe570cc2af675e4a488e3895976bfbf4f96"
    sha256 cellar: :any,                 arm64_monterey: "41d225802703a6ae7adeb3044e41e36402e2e98517aebe4567852e3bd3e4f12e"
    sha256 cellar: :any,                 arm64_big_sur:  "4240ff000419b4ca9c0d275d70fccb10255ea17718906768892ba3a2d7ecb444"
    sha256 cellar: :any,                 sonoma:         "44f6deddfdf79f2bed8c3f44f0dbbc22bd6631c0b29db815ffa685f7b026aace"
    sha256 cellar: :any,                 ventura:        "a0b33bf4a03961de5a66dcd612634e6098fca485bdec229ec5853787e1951d1f"
    sha256 cellar: :any,                 monterey:       "1108a67a9a2046cf987daa49ef63a8ce8b1dd8b011463cd7594fb13e0aee190b"
    sha256 cellar: :any,                 big_sur:        "c9668232e677e92b51210a0563c2156f030837b1fb221de60d16c83c466620b2"
    sha256 cellar: :any,                 catalina:       "fa00c7fc4b6b4ab794439f619ba00961358a4e5684a0ae2412fbd78ba2497df1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "16b246ffcc1d24acb0aba75e1ba6995535470fc90b0992746bd38e3f2aa10243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e3d734fe73f1ca3edeab8e4f25794a28acbdde6df9f3ffd7d01b2e16ce31a2"
  end

  depends_on "pkgconf" => :build

  depends_on "cdrtools"
  depends_on "eye-d3"
  depends_on "flac"
  depends_on "glyr"
  depends_on "lame"
  depends_on "libdiscid"
  depends_on "mkcue"
  depends_on "perl"
  depends_on "vorbis-tools"

  resource "MusicBrainz::DiscID" do
    url "https://cpan.metacpan.org/authors/id/N/NJ/NJH/MusicBrainz-DiscID-0.06.tar.gz"
    sha256 "ba0b6ed09897ff563ba59872ee93715bef37157515b19b7c6d6f286e6548ecab"
  end

  resource "WebService::MusicBrainz" do
    url "https://cpan.metacpan.org/authors/id/B/BF/BFAIST/WebService-MusicBrainz-1.0.5.tar.gz"
    sha256 "523b839968206c5751ea9ee670c7892c8c3be0f593aa591a00c0315468d09099"
  end

  resource "Mojo::Base" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-8.64.tar.gz"
    sha256 "547a2c592e30ab5f22e42af9a84982b5cd699553f51226b6ed9524b4b7f4b24d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    inreplace "abcde-musicbrainz-tool", "#!/usr/bin/perl", "#!/usr/bin/env perl"

    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
