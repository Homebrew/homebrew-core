class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  url "https://github.com/ProcursusTeam/ldid.git",
     tag:      "v2.1.5-procursus7",
     revision: "aaf8f23d7975ecdb8e77e3a8f22253e0a2352cef"
  version "2.1.5-procursus7"
  license "AGPL-3.0-or-later"
  head "https://github.com/ProcursusTeam/ldid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "244b1731df2a4fd86998f450ef8468c3e8146432f138e4d34e5026e1c67cf6ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "080815221a051720f22be34233295190556c516a99be52ef6ddd01303770660d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50fa08dc7167dfb64741eb6c7b423f2972764e45e06a4d8b269a4abc4c38181f"
    sha256 cellar: :any_skip_relocation, ventura:        "463d3d0c21d8fcff6a905c46212a35402c215faffc92ba72c061d7a56404a3c6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e553ff21f53fa3c8d111a0692c5d214265eb2ff362530d66d6350311db48f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e33ec8015cb54f040f112818c7a4de417c4bda73b0856d1ce1ddedf92da3906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd92a11facd88817f7ea51211a599d2e16691f9ace76dde451d013171091089e"
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "openssl@3"

  conflicts_with "ldid", because: "ldid installs a conflicting ldid binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    zsh_completion.install "_ldid"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end
