class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.15.1.tar.gz"
  sha256 "3d29eecdaa845b073bf8413cd54e420b3f48c79c25e43fab5a379dde029d0cde"
  revision 4

  bottle do
    sha256 "cee68143a4d8bb472e85f053f01b7093a357977796cdfb13a996a68011a0b7c6" => :mojave
    sha256 "5bb66072a98aea792244409f27d2a9f0e00921d2e1990fd38dfac982b9f3581e" => :high_sierra
    sha256 "f31e458288a9c332efb8038418ecfea4a2b999aeacf3adc0e1e87bbc77bd5cc0" => :sierra
  end

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  def install
    bins = %w[
      gxi
      gxc
      gxi-build-script
      gxpkg
      gxprof
      gxtags
    ]

    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "std/build-features.ss" do |s|
        s.gsub! "(enable leveldb #f)", "(enable leveldb #t)"
        s.gsub! "(enable libxml #f)", "(enable libxml #t)"
        s.gsub! "(enable libyaml #f)", "(enable libyaml #t)"
        s.gsub! "(enable lmdb #f)", "(enable lmdb #t)"
      end

      system "./build.sh"
    end

    libexec.install "bin", "lib", "doc"

    bins.each do |b|
      bin.install_symlink libexec/"bin/#{b}"
    end
  end

  test do
    ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
    assert_equal "0123456789", shell_output("#{libexec}/bin/gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
