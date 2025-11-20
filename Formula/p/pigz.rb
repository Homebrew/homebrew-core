class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.8.tar.gz"
  sha256 "eb872b4f0e1f0ebe59c9f7bd8c506c4204893ba6a8492de31df416f0d5170fd0"
  license "Zlib"
  revision 1
  head "https://github.com/madler/pigz.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "826d8436f8f3d6f7ec60f78f728f966499f295539f132ae06a20532696742d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2136c50e0f5f4e7078f8e323aa6bfd5dbd170da137e7930f9f4a28d32be4a4e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d530c3e0e7ace1ca42ba8b4f233b42294024ca5b1d896e59d794372a447b70b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8e22780abe73636213e792aa1d9f77593d392508b7ac45f0e0310c6f1c387b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5943909e6487fc62989be3ee2dc9788b28322f6f0025c52f59df30e3dd5e11e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f8eefa10c0d4704e5ab22e5211d683972f25e1573618191e6d29342a838c44"
  end

  uses_from_macos "zlib"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert_predicate testpath/"example.gz", :file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
