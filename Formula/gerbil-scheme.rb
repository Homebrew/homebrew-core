class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.15.1.tar.gz"
  sha256 "3d29eecdaa845b073bf8413cd54e420b3f48c79c25e43fab5a379dde029d0cde"
  revision 5

  bottle do
    rebuild 1
    sha256 "2f37e7bdb87b21d130e83e7f127fdf79f9c489d0ff449fb79bb461285d2d9073" => :catalina
    sha256 "4b1912a019dc4dc2d970da28a8b1408310f88acb77a085e64d5c4a0b02e58c64" => :mojave
    sha256 "1cbb3b62b649c6cf6e813d5d5f00f3cf55e42a4f80acf25f95889745963bba47" => :high_sierra
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

    inreplace ["src/gerbil/gxi", "src/gerbil/gxi-build-script"] do |s|
      s.gsub! /GERBIL_HOME=[^\n]*/, "GERBIL_HOME=#{libexec}"
      s.gsub! /\bgsi\b/, "#{Formula["gambit-scheme"].opt_prefix}/current/bin/gsi"
    end

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
    assert_equal "0123456789", shell_output("gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
