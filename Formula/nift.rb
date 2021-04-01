class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.9.tar.gz"
  sha256 "a9da5c60828a2c0f309b553ab8720001e5a4068a5a5ff47f19f1c1449ea525db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d8689ef747cb873bf071bb8fe59f09431c4f12dc6927f6c87af56e57bd0a8469"
    sha256 cellar: :any_skip_relocation, catalina: "503479f69e94098aac549c9325855d7cdb0f7fd640120696ce28cfb3e9253bb9"
    sha256 cellar: :any_skip_relocation, mojave:   "ed1dc7a1b41be5676311bc34d55f3116f495adf844d5e1a64faca06f2de09ab4"
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
