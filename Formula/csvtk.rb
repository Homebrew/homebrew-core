class Csvtk < Formula
  desc "A cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "http://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "b8ccf2b86c815693af1c7d743ca711a68fcdde94d9a9279ac8557fdffa3f2fc8"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end