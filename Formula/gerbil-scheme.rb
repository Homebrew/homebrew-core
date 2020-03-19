class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.15.1.tar.gz"
  sha256 "3d29eecdaa845b073bf8413cd54e420b3f48c79c25e43fab5a379dde029d0cde"
  revision 5

  bottle do
    sha256 "0add37e8d09b169414d5d2bcee92b7a538627736bcbf645e2fd98d4192564951" => :catalina
    sha256 "a13389f810deb336907262afd0fcc2ff16dc76d84b3f1c3f34a4ed2420345231" => :mojave
    sha256 "2f666385e995ad74108f9e2477f080a1544c6cbd6a796a014d325190722052d6" => :high_sierra
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
