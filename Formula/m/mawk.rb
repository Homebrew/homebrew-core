class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20260129.tgz"
  sha256 "a71fb7efea5a63770d8fb71321ef6ae7afe0592f1aa7f7e2b496c26ccbb392a4"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a905dfb2b09aef26ce3ecb6093c9df6571155e950a1ffdf65f5c75d7de58cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411b3fd2a4bacce3635b62f3668397df7de0bf84df6afcb07bf95e84e21c1ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2c8fc1eb05962130b42a085f214f7742d2532b14fe95c450d5ab3164dec0407"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5abc0c0d665d792fc218a4078f9dd15d55ea7d9345b1e8d2af6fd775e1eba9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28cd099e59c7f6348c7018747ff07d6401157acfbff960a495a4725aa9abcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334826e0041bf977f41b09b305aa725891dbc731a799b620de87ecab3934a4af"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
