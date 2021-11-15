class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.1.tar.gz"
  sha256 "931f01380b48e539b06d65d80ddf313cce67aab6d7b62462a548253ab9b3e10a"
  license "GPL-3.0"
  head "https://github.com/vigna/ne.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "7dd2a938696a36f8c02e371d786b223d67f04e83c998ef932476e48971781206"
    sha256 arm64_big_sur:  "b55c5eec667c1297570a6ef49e989061983a068c4daad9c8e27a85898556b58d"
    sha256 monterey:       "23b806ddde22eb2592ddb308f4ea3b5351b9f05a91f7acdb4ac597a6dc11cf92"
    sha256 big_sur:        "993bb3e19da613eec505a0ad68fe83bee71ff2623d7110b9e09005af7c819795"
    sha256 catalina:       "ecfd40e9e55ae2fe75fe6c8118742de8268ed794784fdff5807c26073832d2c5"
    sha256 mojave:         "4e3b9c4ad9cf331cd239cfe8b192e9f3c6cd9f6609d3726a0fad32ad1c4c9715"
  end

  depends_on "texinfo" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
