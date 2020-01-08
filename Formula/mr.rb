class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/",
      :tag      => "1.20180726",
      :revision => "0ad7a17bb455de1fec3b2375c7aac72ab2a22ac4"

  bottle do
    cellar :any_skip_relocation
    sha256 "90ab23bd6811b507860b5ddcc7e9a181abd3f126fc2ab193739987d6d4b31612" => :catalina
    sha256 "73c8b9b421ea776366f9ded68d90c6c3b75b50401172b5c5248556f6f7f47d6e" => :mojave
    sha256 "a41bcee5b050ec9f98cf5960a457421528b05773867d8c8dbb8eb32716e09fd5" => :high_sierra
    sha256 "bcac4176692f69d47a83cd961cee92e096f6b35f19cb7206973f77b15a1ba71c" => :sierra
    sha256 "75fd9c6fbf6dcf833243e4dc9baf0afe81c422e55d3e251f5cfe040b8bc6a254" => :el_capitan
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
