class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20250817.tgz"
  sha256 "6c59b4671616041dcd75d0d4a1d8646e8ca6b10a1ae534d3b9368c4c4ba29aa7"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ae6bacf40bf541cbd99c15287a9bf2275c9b66f53f5568a66fbdba941fded59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc4c81722c0ecc227033f8beb8a7355d4c8e4f222b2b74d741d4b364f859d0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45aea894881251aa69508ece9a6f900658096220600560064ad69982ddbe3086"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac9a21135457155325940b8266b56eae03f84433104e32959afa707fe64b5a81"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cdeb7edfe27a71aac65b5a503e1101632f6e0d5a5ad5862ed543b7f62eeb5a1"
    sha256 cellar: :any_skip_relocation, ventura:       "68d9086424454c7960c58925581e05c31e2e0204ecbe47951f4b6cdbf29679a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8d26be28d7e6bb7d53034a1518713416214027ae677e0a08339f6758b74f18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc74c305e615d97d8b30a36e3f15f178c9c449db48578f60e6e7beb4141e6fd"
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
