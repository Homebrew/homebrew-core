class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20171231", :revision => "b1e830c793785d2ca9e0644150091293e0c234a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd785ab43994c4209e80bcad7d676b641839ef6df50c5ec1bad08492c212c714" => :high_sierra
    sha256 "952a63655282b3a8926920c103d61a37df79610ce4c03bdfe9259cc239556369" => :sierra
    sha256 "b7af2995198e84cf2dce5ffceabd485e485c17054bd11e3f0032c07968d4b4c8" => :el_capitan
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
