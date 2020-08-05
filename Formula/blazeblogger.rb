class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/blazeblogger/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cb9f78c2ae445f20f90c62b634fa4ee32ac282fc0a005099dcb5593b5008f99e" => :catalina
    sha256 "c7350b4fc7cb74eb436f431aed0e54160bb2da31593f623573b6396287342148" => :mojave
    sha256 "7cb9d122a9c892a89d36a886c2be63536ca339def18d2766fde8f96e87c0d0cd" => :high_sierra
    sha256 "8e6e405d5b586a95006ab1f47d2f5cef961a2dbdaa9759fb4427663edcd12adf" => :sierra
    sha256 "0d6bf439fa6f880cb9457581da66082f49f514f8b0fd4b57ac81180948aaa5e1" => :el_capitan
    sha256 "bac92237da25ffb0b9b31bd78fea353bf717cfb6f1381fbb0df333f555fbab91" => :yosemite
    sha256 "d48ad0f2ce8de2cf98f111a491e47136debbd0e585ff20b9978eb00349e454b3" => :mavericks
  end

  def install
    # https://code.google.com/p/blazeblogger/issues/detail?id=51
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "compdir=#{prefix}", "install"
  end

  test do
    system bin/"blaze", "init"
    system bin/"blaze", "config", "blog.title", "Homebrew!"
    system bin/"blaze", "make"
    assert_predicate testpath/"default.css", :exist?
    assert_match "Homebrew!", File.read(".blaze/config")
  end
end
