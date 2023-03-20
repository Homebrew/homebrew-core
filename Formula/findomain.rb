class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.2.2.tar.gz"
  sha256 "b5d166a1d0e9b86165f1607d5c48c53957f3a2fc734a7cb1707beb9538abdfc5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3176c40b31c3d8b26c3f95e5ef560b5373023b265844c96c0fbfdde5ebc218cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8436c553f6052de418029a77f25dfdfd7b61c1a3e66337018521058dea629298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab0ede693d75114669a2da2c219cdcc321e22acbb18117fe81bc5b981587788"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd26246e1c3319339bf7ba9634268fbf88dfc23b245e55d3935a118fa1167a0"
    sha256 cellar: :any_skip_relocation, monterey:       "6656214e3c559a20e94a383f7613133d8a121814f7c8b5485e127e2040247e15"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2bbc9cb792d95d1f3d459d802fb9d3aebe8c39f6cb196dd36540313a617a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0345179a3fb71f1b6310207de2168d770f2fa996b12d44a0b355c9b1547dcb8b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
