class Imagejs < Formula
  desc "Tool to hide JavaScript inside valid image files"
  homepage "https://github.com/jklmnn/imagejs"
  url "https://github.com/jklmnn/imagejs/archive/0.7.2.tar.gz"
  sha256 "ba75c7ea549c4afbcb2a516565ba0b762b5fc38a03a48e5b94bec78bac7dab07"
  license "GPL-3.0-only"
  head "https://github.com/jklmnn/imagejs.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99e906e8eeb8451f8c2f8408aa990cddb575a02be4cdc5d4ea3f95362d040633" => :big_sur
    sha256 "f03279a8e5c316d74b2b93939714aa16dc624735ca8bda89b20468bc346c4216" => :arm64_big_sur
    sha256 "7bddae8dab41f73bce7acb3c86a6dc01dcd3edeb5e0abf80b155e498372b8e5e" => :catalina
    sha256 "4d071eb79a95c78c190c91ef8295b0a300a0ccdd525b401af2e797767bc54410" => :mojave
  end

  def install
    system "make"
    bin.install "imagejs"
  end

  test do
    (testpath/"test.js").write "alert('Hello World!')"
    system "#{bin}/imagejs", "bmp", "test.js", "-l"
  end
end
