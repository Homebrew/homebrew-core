class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.4.x/duply_2.4.1.tgz"
  sha256 "03fd28b06206505edf0e0820d098208708842999f21b1d132461e34e2c0b6973"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39cdaa9f4f7d6970a081025aece74304e18f9f772f3e41014cc60899f6e41959"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39cdaa9f4f7d6970a081025aece74304e18f9f772f3e41014cc60899f6e41959"
    sha256 cellar: :any_skip_relocation, monterey:       "c276740735afa2f49b914fa476fab536b3491c862ffa3e9cd0ddc7e7b3ccffef"
    sha256 cellar: :any_skip_relocation, big_sur:        "c276740735afa2f49b914fa476fab536b3491c862ffa3e9cd0ddc7e7b3ccffef"
    sha256 cellar: :any_skip_relocation, catalina:       "c276740735afa2f49b914fa476fab536b3491c862ffa3e9cd0ddc7e7b3ccffef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39cdaa9f4f7d6970a081025aece74304e18f9f772f3e41014cc60899f6e41959"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
