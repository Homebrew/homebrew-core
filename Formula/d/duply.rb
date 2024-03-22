class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.2.tgz"
  sha256 "b35fca2e12212ac054de450f3ba243a43c4e4cef5f13baa1f900776f81e9de47"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf31f8fdcdaa4c5f9d109ae44d679be5f2e1df85ff56ce10985dcdd97b88740c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf31f8fdcdaa4c5f9d109ae44d679be5f2e1df85ff56ce10985dcdd97b88740c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf31f8fdcdaa4c5f9d109ae44d679be5f2e1df85ff56ce10985dcdd97b88740c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fde16ad45662ad5828be888d8e60791d491b45269dd3362594a24bde0c58594"
    sha256 cellar: :any_skip_relocation, ventura:        "4fde16ad45662ad5828be888d8e60791d491b45269dd3362594a24bde0c58594"
    sha256 cellar: :any_skip_relocation, monterey:       "4fde16ad45662ad5828be888d8e60791d491b45269dd3362594a24bde0c58594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf31f8fdcdaa4c5f9d109ae44d679be5f2e1df85ff56ce10985dcdd97b88740c"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
