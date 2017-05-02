class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20170129", :revision => "60e9c44a2c2cc884988324aec452e11339d7b20b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ef14ce20e60b88a882e156aad6fbede00d0ae852355950bbb014391993edbe2" => :sierra
    sha256 "7c84fb8bb3d5ec8dd1b175a9805c9ee92be1cc0c1f0fca81f2557c0483301661" => :el_capitan
    sha256 "c7b3005af6e349badfa7f8f99911217ec0138b3236143189fdb715f61cb2ffe1" => :yosemite
  end

  resource("test-repo") do
    url "https://github.com/Homebrew/homebrew-command-not-found.git"
  end

  def install
    system "make"
    bin.install "mr", "webcheckout"
    man1.install gzip("mr.1", "webcheckout.1")
    pkgshare.install Dir["lib/*"]
  end

  test do
    resource("test-repo").stage do
      system bin/"mr", "register"
      assert_match(/^mr status: #{Dir.pwd}$/, shell_output("#{bin}/mr status"))
    end
  end
end
