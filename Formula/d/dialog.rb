class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20240619.tgz"
  sha256 "5d8c4318963db3fd383525340276e0e05ee3dea9a6686c20779f5433b199547d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f7090669978888d1cac3055e3eb119055cbbf63d5adef3cd370480096253d6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5c48877fe16832b1ab4898c94a642e8b5bf78683202a9996498a0049e0217c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf1e44f6a3456d9fc125a5c980df2a45cb104cd8d6b3883c7617743ff0ef9a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a639f7053e72045fd49d4ea0d48d89d56d82261c881bdedc9f48806489cdd99"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f95c25a531ae22049228e4b326ac6a34407fa6c9bb2ba1c95aa142546fa0333"
    sha256 cellar: :any_skip_relocation, ventura:        "0566e9e30b16caa72edd7890d9abfc362f1a4b2f246ed5ac3ffe5604d9a0aeb6"
    sha256 cellar: :any_skip_relocation, monterey:       "80e53812d09c9edee3593f510b6923b02c808c81d2de6f490dde51a615c27d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d4079965af97a483e15e0141ead64496a412008bf17021485a28680eeb7aa4"
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
