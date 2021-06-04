class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.75/putty-0.75.tar.gz"
  sha256 "d3173b037eddbe9349abe978101277b4ba9f9959e25dedd44f87e7b85cc8f9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c133fac55c1f754b779ee81f4b8a5b1e21072c39409edcd0d96a723927dc7ac5"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c3cd8e013706720ba56fcc38107051dd05eb36daeaac785a46c93695641357b"
    sha256 cellar: :any_skip_relocation, catalina:      "f7913ffc65271e850f1689f3b5cfa0105cfcb72f06697cc9e66a0850dd4dc9f6"
    sha256 cellar: :any_skip_relocation, mojave:        "79b879541251665356f72102b11cced22a2ed6c56bf7131235b77ac8a91f555c"
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "halibut" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "expect" => :test

  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    if build.head?
      system "./mkfiles.pl"
      system "./mkauto.sh"
      system "make", "-C", "doc"
    end

    args = std_configure_args + %w[
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
