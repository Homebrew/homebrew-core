class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.5/posh-debian-0.14.5.tar.bz2"
  sha256 "dcb22cf8761f1d7c805f9af08dd1e91a91079850fd0b56df88c2240fa3e5f8ac"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4c49c448bc48352595390ec617225d314607e4252a3a1c2d09f359c94132ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8ed5ec9c2e118a4f7e338a96f0220b3f07a0a4290fb0ee07244e86ef95b119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57d832f54a956df8d62cfbb91debefee44c01572488e553e0913238b528fe84"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ea534ecc8db83c349191c2cc289025bc7b07b9c6b41506bda1a36b53aa7f831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55dad8d1b9709fe46183a0a0770f848221b685a7d70bec2120d7fcfb7fb55ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ea129f3be132e51c8eadcc1d7fc1fb00a330e62d2fa9fb69e69a6e79e2399a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Upstream still uses K&R function definitions, which do not compile as C23.
    ENV["ac_cv_prog_cc_c23"] = "no"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
