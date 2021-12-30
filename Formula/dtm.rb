class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "64fae905308fd3ab6e5e0152aa98e388e37eb73764af82b5c6212121ff96892c"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"dtm"
  end

  test do
    assert_equal "version: 0.0.0-dev commit: NA built at: NA\n", shell_output("#{bin}/dtm -v")
  end
end
