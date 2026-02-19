class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3b02903a82a77d89d14776957ba50c442e5bdf8948079c65ed927d80765f04a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ebd88e28e9fdc4af031759fae5cfc6b4f93489e2aff78924d0a0b41ab4d9ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b725467f89444f309fe6ac39a1e8c93dfde4d58ce9ab1bc8f92a49beb899e1de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b725467f89444f309fe6ac39a1e8c93dfde4d58ce9ab1bc8f92a49beb899e1de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b725467f89444f309fe6ac39a1e8c93dfde4d58ce9ab1bc8f92a49beb899e1de"
    sha256 cellar: :any_skip_relocation, sonoma:         "a15ddf828a10f73b8ecbc8126bc6a5b9c659c94dcc9f8c3f761cda1a40e725cb"
    sha256 cellar: :any_skip_relocation, ventura:        "a15ddf828a10f73b8ecbc8126bc6a5b9c659c94dcc9f8c3f761cda1a40e725cb"
    sha256 cellar: :any_skip_relocation, monterey:       "a15ddf828a10f73b8ecbc8126bc6a5b9c659c94dcc9f8c3f761cda1a40e725cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dfd00166b42210512d2499bf7d45eb3bd86bc4b64f0c40f9da0f57b15710ba22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3760928e8e228b469f78ad5ebf3468a745b6dedbbeb7b7968b4f4ac7ae40bd5"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "perl-xml-parser"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
