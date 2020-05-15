class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.9.tar.gz"
  sha256 "afc5fe6011be31e3eb05c46f0dbe7de62365d4bca51310619d9add0e99ae91fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "801ddbb3b789d00425b908c2b11e0410dc486a3ef4ef52ebc97021bba4477571" => :catalina
    sha256 "47bed5d6082af273eced0323100ffd67874fcfe03d131d8e9745dec67f846f4c" => :mojave
    sha256 "b4560359c2f69e2ddf978c7dd57f7b9d8182a8d60c3539ecb6737ee4d290719e" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
