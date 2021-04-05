class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.10.tar.gz"
  sha256 "3a7292d82471ed19ef6d723f40e4319ca9108275d49f13a583f61f21ff6dbb20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "04b46551d7a1e0ae9adb2e1af9a768d119543490aca901287d9dbb96c03bfd9d"
    sha256 cellar: :any_skip_relocation, catalina: "82824e8885876faacc066c28a4a79092202effbf7f8eb41d0ec881308bbb25e1"
    sha256 cellar: :any_skip_relocation, mojave:   "69d14f5ba918e3b828998e898b58dbd4239482fe5ea9520363c5f784eb62b5a4"
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
