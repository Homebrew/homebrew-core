class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "a4433a45b73ead907aede22ed0c7ea6fbc080f6de6ed7bc00f52173dfb309aa1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "896c7233e9f91a6a6ccdaf4d9327b77283bcb8af87234c957905fb46f1643cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8f771d05f2b2a193c0bdac1ffdbae8b9213e1cc04a0c92d35135d4d5504262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ace6d9c876a32e46322733499ec9c331d56d48f3a4c567f997bc43e3304deb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2efcd4380b4a9be30bcaa32552abe16aee7742860c49b4854651f3775914d118"
    sha256 cellar: :any_skip_relocation, sonoma:        "324c6792d35fed4dc9a80e8853261cdfc232f9510d4480878ec774e20d5f733b"
    sha256 cellar: :any_skip_relocation, ventura:       "04770b3b45993c485713def1d48d104c8ddd83b95fe12a02a45860b04d171423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b32f3d296d346274a86d5f9a29e7af74afcdbcc76545536f311c8f9d4954f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac45069d93dbe0781c369b55b7252bf863d7cc379c359b4e56d4bb589e35fd1"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    examples = pkgshare/"examples"
    args = %W[
      --bzip2
      --file1 #{examples}/reads_1.fq
      --file2 #{examples}/reads_2.fq
      --basename #{testpath}/output
    ].join(" ")

    assert_match "Processed a total of 1,000 reads", shell_output("#{bin}/AdapterRemoval #{args} 2>&1")
  end
end
