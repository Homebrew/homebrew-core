class Gzrt < Formula
  desc "Gzip recovery toolkit"
  homepage "https://www.urbanophile.com/arenn/coding/gzrt/gzrt.html"
  url "https://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.8.tar.gz"
  sha256 "b0b7dc53dadd8309ad9f43d6d6be7ac502c68ef854f1f9a15bd7f543e4571fee"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gzrt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "057453d434a240760d24796e6ac12e0d6253d734527f31de476432d8e81b2818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a8383b91ba90e35c7cf4110167a631482dbbf1798faf36ab193ab2072aadfec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0aafbc9d11bc14764a79f044072cf6bb3ae9686fca63c2ccdad9b7001c77c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6dfe52fd268de29704f3367daa802012d68b7162d957716d96d9da41bef80e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46794bf9bc734a2a73e7f7b8f9bb16825249bed562bd516a97aa8b2b3349b264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1bc6db3fef40f0c48ceac080ee84108364cf4ff1d94bb1423c1be5b2f14bc96"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05c7de51bda8a52b47b8e8a3b8c8ec146d32c421992b94e2b99e67461de3adf"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb47aeeccbaacbeefddc130b44f5c36e7660067dce5c903ebceac40199db8bf"
    sha256 cellar: :any_skip_relocation, monterey:       "003e9f13cb64da84793030b3b224e9dc2083b97b7bae69527857bb359f856331"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9f146178364bb1306a145076a4c79f01f1ba08726b2e90a022597fe34b63f9"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d5378de11679a973ce6a5893984b0431f7ad62f369215814927cdb5fbf6678"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "654f7cd9822abb04c3e99f03452260a1ba3adb935d74199dfee2c67530b0eb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befaf922391daf55b95098ef2c66c02fcd04813517cef56c60caf3cd1297d986"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end

  test do
    filename = "data.txt"
    fixed_filename = "#{filename}.recovered"
    path = testpath/filename
    fixed_path = testpath/fixed_filename

    original_contents = "." * 1000
    path.write original_contents

    # Compress data into archive
    Utils::Gzip.compress path
    refute_path_exists path

    # Corrupt the archive to test the recovery process
    File.open("#{path}.gz", "r+b") do |file|
      file.seek(11)
      data = file.read(1).unpack1("C*")
      data = ~data
      file.write([data].pack("C*"))
    end

    # Verify that file corruption is detected and attempt to recover
    system bin/"gzrecover", "-v", "#{path}.gz"

    # Verify that recovered data is reasonably close - unlike lziprecover,
    # this process is not perfect, even for small errors
    assert_match original_contents, fixed_path.read
  end
end
