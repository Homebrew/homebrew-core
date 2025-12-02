class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/blazeblogger/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "4f76e3eb4cb3ab302fdf746ec68a54f42422913c10916429788affadad93209c"
  end

  def install
    # https://code.google.com/p/blazeblogger/issues/detail?id=51
    ENV.deparallelize
    system "make", "install", "prefix=#{prefix}", "compdir=#{prefix}"
  end

  test do
    system bin/"blaze", "init"
    system bin/"blaze", "config", "blog.title", "Homebrew!"
    system bin/"blaze", "make"
    assert_path_exists testpath/"default.css"
    assert_match "Homebrew!", File.read(".blaze/config")
  end
end
