class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.1.tar.gz"
  sha256 "0d2330e3c46ce21d7fa3d29f0f99b9527eb5ab323b1efb9b1a0e6915779c74d6"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd7b0294eee70146184cc38c4d0f177e98e37243def58d237279642d835019be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44f5920711c2eb79e334cd7bc4b5972c9b3010a0345607b8c59ee71b1e2391c1"
    sha256 cellar: :any_skip_relocation, monterey:       "40549f7255b1cdbbefebe03deccd815fbbf6477c3b603703615a287b6329a054"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4af428b5c74fed903aca3337334bf0d418fd9765ea50d73ac2f308c60f7061"
    sha256 cellar: :any_skip_relocation, catalina:       "b1d926918eab64e133117b5089f17c51f0a0888d7ed33448fd3247e05a15e919"
    sha256 cellar: :any_skip_relocation, mojave:         "277176751578539b28b96e3d18f1ca9efa576b270e6ee6a42a7f4fdea317c061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732a47d87de00dc02478feb7dede8ba1a5941ce10ededd895cf96f5111e71f4e"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
