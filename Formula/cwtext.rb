class Cwtext < Formula
  desc "Morse Code Generator"
  homepage "https://cwtext.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cwtext/cwtext/cwtext%200.96/cwtext-0.96.tar.gz"
  sha256 "db108e6f510583edf4a285c6d6ab9ab9fdffa3bc5682903b316fd10e1e12393e"

  def install
    bin.mkpath

    ENV.append "CFLAGS", "-Wno-return-type"

    system "make", "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system "true"
  end
end
