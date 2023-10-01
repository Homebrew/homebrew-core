class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/9.0.1.tar.gz"
  sha256 "76fc0d63e615abf0cf3b57715ec9be18cd08e6e4d4e1d43a69618fa2b2709d49"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "573d124fea2499ef901096a2244a0657f81b6caa87a85d085b4dece5a8f1f529"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33756792fdb409805d0697184424401721cc7988f89111831d071bcc445c8556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab860df135b9e57214929390c61887ff50beae41cece9f28c2969caeaee6d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb37f59cf7e063dab1e8a8a2f80aace64233472e575e8d36ee2341ff880455b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ffe9bcadf1ded1671dd2b23267e43fe6c02c3446015ebc84d786689b656731d"
    sha256 cellar: :any_skip_relocation, ventura:        "33b2861bee376c982dc138cf3dfc2a7117a4a8fc1bf185f73d9736376f80bbf4"
    sha256 cellar: :any_skip_relocation, monterey:       "5891670f06590d157466a1ce28be2bd5cc16a0fc2322a36c6a5714d1d1cdae76"
    sha256 cellar: :any_skip_relocation, big_sur:        "a04a3621aadd2a40bb43f98641b69f33c587cf3e8898b3a859138d4a3282a1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c3975d3b0d1051994d6bfdc7f561873029c48fb253ea004532f2a96b66234d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
