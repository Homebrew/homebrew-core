class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/5.2-1.2.0/bashdb-5.2-1.2.0.tar.bz2"
  version "5.2-1.2.0"
  sha256 "96fe0c8ffc12bc478c9dc41bb349ae85135da71b692069b8b7f62b27967ce534"
  license "GPL-2.0-or-later"

  # We check the "bashdb" directory page because the bashdb project contains
  # various software and bashdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/bashdb/"
    regex(%r{href=(?:["']|.*?bashdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce33c2ad50ddabd3cbff0c1a2b6e0f9ebaf8ff28609df48fafd6d7e8e1c8962d"
    sha256 cellar: :any_skip_relocation, ventura:       "ce33c2ad50ddabd3cbff0c1a2b6e0f9ebaf8ff28609df48fafd6d7e8e1c8962d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aedb1af38194b056e6f3a31ff73c2995782f41d714955991a5d749abe53eb14"
  end

  depends_on "bash"

  def install
    # Update configure to support Bash 5.3 by replacing `'5.2' | '5.0' | '5.1'`
    inreplace "configure", /(?:'5\.\d+'(?:\s+\|\s+)?)+/, "'#{Formula["bash"].version.major_minor}'"

    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end
