class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adc416c3d767931c3220285e2d2592f4b9fe037c35aab51a0bb18b17905cd08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7de95125177db2598a17b99514154a5414d74781c642397eae752645cae9c64"
    sha256 cellar: :any_skip_relocation, monterey:       "259bbbe1bdff8ebb05d6e9990a4450ba5cb3684e1903070483b22a7030546646"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b9e20ce5c2142da8ea4a1bbc34ff433da46a1e12a522942c3b7c572be9f683"
    sha256 cellar: :any_skip_relocation, catalina:       "6912247da18b0d7f033d37115939a67629b93d036458f1369944a58953c12f69"
    sha256 cellar: :any_skip_relocation, mojave:         "1d327ce17e123f4039b9b0e6c351277d8e781a6757dd23060b6b207d791380f8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7ac3822649356127001c8b452df55c1435c467938193f223da61bbcdf2a7c11b"
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
    system "#{bin}/mobiledevice", "list_devices"
  end
end
