class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.14.tar.gz"
  sha256 "8525877960ba7a6122d6dfd2bae34ed1437d5231f9e31de97bbe6106c4dfa03a"

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl"

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
