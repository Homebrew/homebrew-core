class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://github.com/nurse/nkf"
  url "https://deb.debian.org/debian/pool/main/n/nkf/nkf_2.1.5.orig.tar.gz"
  sha256 "d1a7df435847a79f2f33a92388bca1d90d1b837b1b56523dcafc4695165bad44"
  license "Zlib"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nkf/"
    regex(/href=.*?nkf[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "157d2e7be20ab0ff292a84336421a6c0afdb541abcc04d7b05fe4aff25d3bbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f233b8fbb5fe59f101fff8e47bf2e4c4dfcd6baa59011fa831f0f34871dcb998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9508578eda712a4a0e89b216afa1a4adc5368f62d52a3ddcf5351e6eb0774e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5f70e92b04d9c3a5e1abe9d2fa887aa8883d032cbbac71365f1205628f83a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d61677ea7823ccdf8df32e1d7d780a9bcab90870c0de9a1354daada079ea626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5283ee3b17553f3145b602bcdbda3e23d843934a7a0d4543217c1b4355737d80"
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end

  test do
    system bin/"nkf", "--version"
  end
end
