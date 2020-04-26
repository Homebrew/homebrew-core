class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.6.tar.gz"
  sha256 "0176eaa37ed9f92fbf09ed4fc0f73dc9a560c3cddba83e70586ff096356e9466"

  bottle do
    cellar :any_skip_relocation
    sha256 "59c78ce930e5fd55149cd8ad8fe6b2ea57364d6ae038db4e08d4242e49847ff5" => :catalina
    sha256 "54054a65d96046bde9d901a9f140e96752f0a3c7f14e73e05e90e40cc906283a" => :mojave
    sha256 "1d314159a7133ab707da24005fb2a9edb81bc05d5b8b9649c8a16909b0fd0ac0" => :high_sierra
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
