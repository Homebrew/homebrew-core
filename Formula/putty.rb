class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.73/putty-0.73.tar.gz"
  sha256 "3db0b5403fb41aecd3aa506611366650d927650b6eb3d839ad4dcc782519df1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "37ba26e6b965281083a75044df48335b9dd4eb06c2d3893af3c904ce73df633f" => :catalina
    sha256 "765e7d374a8f98b1d336e5120fd9e9e07cddd75c0f9ac68fe9bdbde577193620" => :mojave
    sha256 "cdba0d03e5de13733fcf62307656adba84d872ae5b97cdde77034ef97de5e63f" => :high_sierra
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "halibut" => :build
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
      --without-gtk
    ]

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
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
