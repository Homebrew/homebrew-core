class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4d608ed86533b0ee3b7d4a238ec183201ba63feaa8ae11d14961b92c2cb9b718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2c9834f05f9113dbc7c62003fb60463b071b6b7391d4060cabd1e2b9f62efc4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb9aac82b25b78b834109a161d48b357342e716af6e88f384c4709cfb7712aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01f1aad2d6a402313f960430ce120e07a8613a6eae066bfb2cc1480da4b0bdea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e8e4e938de5aeb9544c33319d88e41f70d98dec7fd21008d1c0b79774860cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "18d4e96aa9a4e9fed3087a9a042e1d5db71228b50f9e90c5e4721161a827c012"
    sha256 cellar: :any_skip_relocation, ventura:        "8a586e0a6b3ca5aa6e75d71c417a43d9273a03bbeedb6caec98bea43037bea64"
    sha256 cellar: :any_skip_relocation, monterey:       "acc746601cda076bc612d2f19849c6be0ab85999da3390426cb442608c669add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62cfd6b1fe467b630ec4ae563557965739c05d115c9012882814866ae1cb197f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"export.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
      <en-export>
        <note>
          <title>Test</title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><div><br /></div></en-note>]]>
          </content>
        </note>
      </en-export>
    EOF
    system bin/"evernote2md", "export.enex"
    assert_predicate testpath/"notes/Test.md", :exist?
  end
end
