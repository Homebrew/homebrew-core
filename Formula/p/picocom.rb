class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://gitlab.com/wsakernel/picocom"
  url "https://gitlab.com/wsakernel/picocom/-/archive/2024-07/picocom-2024-07.tar.gz"
  sha256 "4379de2ec591a5848123f37ccdbc7fbeee6dd3520ef1ce4119d84202fc268a17"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0b57bd8a770c0e6f67d847470a806c3cd61d11559c3144d58305ab021a7a0b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "286ea19a5c354df6945f1e2ac963c6de413004013d342ec27b0b5a2b6ac37c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eeaa2ad46eb0932dec9c49251dfe3454c59d1584a868a85ae639eedc8f6587c1"
    sha256 cellar: :any,                 arm64_linux:       "5e6ce40c6d0ae12246931299ac5d5f0b2390e09674787f2c1e29088e6e18c7aa"
    sha256 cellar: :any,                 x86_64_linux:      "bab4c83759c1ad5b0c69bf3ae7894c8bf6eeb14bde86c691376c5650aeed62ed"
  end

  depends_on "go-md2man" => :build

  def install
    system "make", "all", "doc"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system bin/"picocom", "--help"
  end
end
