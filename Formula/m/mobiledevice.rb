class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "391242e35998f146f7b0051104f106b49f9ba4f2ec2817b2cb086fa23aa48831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7e9e7bded8a827c41f1fc47bcb6d25ab25dff835e0d7ec486c15ff1e49043de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c41bbb7022712c16b68af49b5b3b170592870c0cf82a6ab3ad778c6731d3adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9840294891d057da453f01b2f91601f9a167c3954e1953f0d48f6d096de0e692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adc416c3d767931c3220285e2d2592f4b9fe037c35aab51a0bb18b17905cd08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7de95125177db2598a17b99514154a5414d74781c642397eae752645cae9c64"
    sha256 cellar: :any_skip_relocation, sonoma:         "60f7ec7961466d17cee5a093926a00a906f99e944bb9f6dbd0daa0e54f9b5767"
    sha256 cellar: :any_skip_relocation, ventura:        "9289a82ea82bad8477cd20b62298ecbe738103a7c6ff1a5ecce316c3056ae85e"
    sha256 cellar: :any_skip_relocation, monterey:       "259bbbe1bdff8ebb05d6e9990a4450ba5cb3684e1903070483b22a7030546646"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b9e20ce5c2142da8ea4a1bbc34ff433da46a1e12a522942c3b7c572be9f683"
    sha256 cellar: :any_skip_relocation, catalina:       "6912247da18b0d7f033d37115939a67629b93d036458f1369944a58953c12f69"
  end

  depends_on :macos

  # This is a simple change that permits building on newer versions of macOS.
  # Should be included in the next stable release.
  patch do
    url "https://github.com/imkira/mobiledevice/commit/0472188d875382c5535916bf4469a2de7696fd39.patch?full_index=1"
    sha256 "76094a3e39e287c88bb60c829d2e9ab8801f8638c116d95a16333198b236147b"
  end

  def install
    (buildpath/"symlink_framework.sh").chmod 0555
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mobiledevice", "list_devices"
  end
end
