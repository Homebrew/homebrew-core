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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "670cc86444773ca0a6a1b37c47b02eedb11a330d9ee4a002be567f4721dce63b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e434b1fa6c32c30f1df2ca06548ac3ba24a4af85653c469694b063e11051d9a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f5aeefd8bfeb62e6108b8d7dc18ceac98abd3958dcb1c50addfc7b7d1357a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "640d5955f8d200207a1a10bcbaff18a3029a2f55e8dd664584d90c987b5e17a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b0cb361639c0127289a8843f8cea433e5e1cddb46522944d1c99d7b34d6f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ed5bc35e21d41cb7add82444259b36d1e0b86068dddef561c44e78fbeecfa5"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
