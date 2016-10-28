class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.10/pngcrush-1.8.10.tar.gz"
  sha256 "ed8dc4759d5067ebf53a2a5188eff1e8ad10262737cf50516cccf8c60d220b6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0578907df55599726514132140ec1fb8c8d06147fd540b0cc4b40bfaf7c401c0" => :sierra
    sha256 "a504ee123b789201327fd9b38662e9d6e17dc54b8d37fabaa1bed88e0c75904a" => :el_capitan
    sha256 "487776323605a5439a28ae82456b19b30fa648d30dbe4e696abb0da4ee6da6dc" => :yosemite
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default
    # since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
