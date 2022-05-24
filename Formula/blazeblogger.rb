class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/blazeblogger/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971cf089545d50d6b751253a1ffe63b4bc3cb10c55287bf5f43cabcee9088afa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c1a4c1663a7da5774e534eec48e6ab245f22d20f1f98a3186b7877f8bc4bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbe0fa6acb72e64523b98192c50de16a12c919e91a7467136876d25c60372fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "595702af4db6b12264bffdfa430b29c55474e15fcb9fc95cf7dec509dbe1bce5"
    sha256 cellar: :any_skip_relocation, catalina:       "cb9f78c2ae445f20f90c62b634fa4ee32ac282fc0a005099dcb5593b5008f99e"
    sha256 cellar: :any_skip_relocation, mojave:         "c7350b4fc7cb74eb436f431aed0e54160bb2da31593f623573b6396287342148"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7cb9d122a9c892a89d36a886c2be63536ca339def18d2766fde8f96e87c0d0cd"
    sha256 cellar: :any_skip_relocation, sierra:         "8e6e405d5b586a95006ab1f47d2f5cef961a2dbdaa9759fb4427663edcd12adf"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0d6bf439fa6f880cb9457581da66082f49f514f8b0fd4b57ac81180948aaa5e1"
    sha256 cellar: :any_skip_relocation, yosemite:       "bac92237da25ffb0b9b31bd78fea353bf717cfb6f1381fbb0df333f555fbab91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534e43639b7ee566bbc9f675f94043e4579b0e01ba1b8b5651dcd308f640a182"
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
