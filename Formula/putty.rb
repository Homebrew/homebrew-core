class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.70/putty-0.70.tar.gz"
  sha256 "bb8aa49d6e96c5a8e18a057f3150a1695ed99a24eef699e783651d1f24e7b0be"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf7d4ac28f94d4486e3edd4424d86c7074cd5dd59a876d49a03b6d248277260f" => :mojave
    sha256 "832bf75b4d9927e461c853e802a7951724522fd083a0774f0609141965c06c82" => :high_sierra
    sha256 "b212b6d5db7478c43d0f6883c459373e257219f9bfc4aa24abe2992d82f9294e" => :sierra
    sha256 "658a1736398dedd1dc5bc1c267c08b126a6bd9b2653fb2ef3b425f401a14f293" => :el_capitan
    sha256 "ef3e944e9b322ce16da3264e68bce6a23f58a23f45f8d84d27954670a8d71379" => :yosemite
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "halibut" => :build
    depends_on "gtk+3" => :optional
  end

  depends_on "pkg-config" => :build

  conflicts_with "pssh", :because => "both install `pscp` binaries"

  def install
    if build.head?
      system "./mkfiles.pl"
      system "./mkauto.sh"
      system "make", "-C", "doc"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-gtktest
    ]

    if build.head? && build.with?("gtk+3")
      args << "--with-gtk=3" << "--with-quartz"
    else
      args << "--without-gtk"
    end

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]
    bin.install %w[putty puttytel pterm] if build.head? && build.with?("gtk+3")

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
      man1.install %w[putty.1 puttytel.1 pterm.1] if build.head? && build.with?("gtk+3")
    end
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert_predicate testpath/"test.key", :exist?
  end
end
