class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "https://primer3.org/"
  url "https://github.com/primer3-org/primer3/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "805cef7ef39607cd40f0f5bb8b32e35e20007153a0a55131dd430ce644c8fb9e"
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-or-later", # Amplicon3
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b96d43ea44fb89eaf75ea0f5bcc76877ca7d73bac9dc4d2084f971c7e5a3d04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7272f6819aa6154307869334e14b9c6bf7f7e2946cb29e6ce27e0e32b591772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe6b4f0f13b4c390a9b0760ec731e50fe176456d404ef253d0b2836fb0924aa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f669fca578e49237e85cfa9ebb37eef493657afdbf7152349d69addb91d4a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4742c4eb4d8eb8194804c426e4bfcc99816751a67d0a8ed3a9f9a762aa7f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "0451ce226e2aab9d03dbac0cf45b7790650dda666246a0c8f7789c407cdd34d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0022a10895d283cf54cb3c24136a31643345487d75b39d355aa68340ce8904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "858d715a269e3ecad988c9bbbf7e04df1570e85f601a43bcde16fb8ee94255c2"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
    pkgshare.install "src/primer3_config"
    prefix.install "src/LICENSE_GPL3_for_Amplicon3"
  end

  test do
    output = shell_output("#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20")
    assert_match "tm = 52.452902", output.lines.last
  end
end
