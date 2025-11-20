class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20251001.tgz"
  sha256 "bee47347a983312facc4dbcccd7fcc86608d684e1f119d9049c4692213db96c3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68ec9e42c550d5c62f088383223783b955e0615c925597eee3d1d98cd10d55da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92e624e85a906113a3f63a38286cbb8edce284492abf726418eb08e8910482f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4256eeb7e61680e194407cff81fd7843af39bdc82a960c37b4618c283b85b61a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1346d2edcd08fb7689862d490f6e028682d5ed264619078908785b3fad5be24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e8eafbb73505ef005ed6119a1b71c2706f719aacc4d9219dd7ecd4a0e339b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a9e9d2798934313e6d47d685de2a3fb692a4dbfbe927005d3d6c3215fc292e"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system bin/"dialog", "--version"
  end
end
