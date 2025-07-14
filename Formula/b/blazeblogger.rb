class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/blazeblogger/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8dc5296ef25d1c5289d74505f6db5c963263054ae78624b237321844e7b3aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8dc5296ef25d1c5289d74505f6db5c963263054ae78624b237321844e7b3aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8dc5296ef25d1c5289d74505f6db5c963263054ae78624b237321844e7b3aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "611443d1770dc0b3af0b0f4ca3af47fe7890ccfb72bf43512ded5c759cc9df08"
    sha256 cellar: :any_skip_relocation, ventura:       "611443d1770dc0b3af0b0f4ca3af47fe7890ccfb72bf43512ded5c759cc9df08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8dc5296ef25d1c5289d74505f6db5c963263054ae78624b237321844e7b3aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8dc5296ef25d1c5289d74505f6db5c963263054ae78624b237321844e7b3aa5"
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
    assert_path_exists testpath/"default.css"
    assert_match "Homebrew!", File.read(".blaze/config")
  end
end
