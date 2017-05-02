class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.69/putty-0.69.tar.gz"
  sha256 "b7dad241ff01b0cbb9dc4c1471ec7cacf8f08d98a581aeb2f336da3c0eb96ad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "14d0e4629c24708e917c72e0f62d7155bda0fb1bcc4c8bc4d652890728be6702" => :sierra
    sha256 "a728b44186b826ea90aec27762ade0da048de36b2ef46c75518bfca05fa683bd" => :el_capitan
    sha256 "682adae37dfca5f5673ed1fd2a6642bc752afc598b055ccbf697916658d752bd" => :yosemite
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "halibut" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
    (testpath/"command.sh").write <<-EOS.undent
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
    assert File.exist?("test.key")
  end
end
