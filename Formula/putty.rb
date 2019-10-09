class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.72/putty-0.72.tar.gz"
  sha256 "f236b5a26b0905809b3cd190158e8b95d81f86ad34fdd97a4312c1877f2cec5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "313fbb8ce87abb346c30d8f43ecf5b5838e25f257974f64c57211488d4954fc3" => :catalina
    sha256 "039baa96e05a37924ec3a9fbba5c8c04ff6524123e5295196bc12a67ce98dbe2" => :mojave
    sha256 "8cccc7fcb0cc05069a9e1ed4f0a44e31458efc65b593a7cdd4f14ca48b1a9564" => :high_sierra
    sha256 "04e18801cd8a061f79faa6d3e72bf4d8b3c61f8787fec5a3e8d6156c1946ff9b" => :sierra
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
