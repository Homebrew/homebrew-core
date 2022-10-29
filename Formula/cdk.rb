class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20221025.tgz"
  sha256 "03ccfa21c9fc3d61ddd0fda19da545359055bbeef5a1c882dfb9ff48f3746af2"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de2152e4b6966e44e4395ea8ba8566fd347c45a7fab74856becc60baf8fb7044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb8998a972586a97ff4dcac9d3d18d697897acafe0ca97e85cd47bc7c38eee8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce6f9990fdef9653805f147fd30fafe62b341412303c65a0b1c716717b98b9f0"
    sha256 cellar: :any_skip_relocation, monterey:       "5018afff5b9e50af60aa2ed1276e278040beb5f12cf46f898cb5c138e0857908"
    sha256 cellar: :any_skip_relocation, big_sur:        "486212a289225b5162617397ecce6889c0e4ac1213d442bf608c7e74d41dc9d3"
    sha256 cellar: :any_skip_relocation, catalina:       "19c3e28cac8d46adee23b18c76ef8efddb45c070d2534843c6da99db63afb2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb11fc41a38ad169f8c907b64ccb9226c562aef6ff34f5f4eaaab0847f0241a"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
