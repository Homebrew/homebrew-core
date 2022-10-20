class BzrUpload < Formula
  desc "Bazaar plugin to incrementally upload changes to a dumb server"
  homepage "https://launchpad.net/bzr-upload"
  url "https://launchpad.net/bzr-upload/1.1/1.1.0/+download/bzr-upload-1.1.0.tar.gz"
  sha256 "a48fc56d83114d9ab946cc358a5b33cb05e134787be135eb0a499317d6dec7fc"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ed703bbd059cad6589230219b1425f5bfc4d67c15819da557e6b72813b0b476"
  end

  deprecate! date: "2021-08-19", because: :unsupported

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/upload").install Dir["*"]
  end

  test do
    mkdir "destination"

    system "bzr", "whoami", "Homebrew"
    system "bzr", "init", "project"

    cd "project" do
      touch "readme.txt"
      system "bzr", "add"
      system "bzr", "commit", "-m", "initial import"
      system "bzr", "upload", "../destination"
    end

    assert_match("readme.txt", shell_output("ls -la destination"))
    assert_match("bzr-upload.revid", shell_output("ls -la destination"))
  end
end
