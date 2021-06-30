class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.17.0.tar.gz"
  sha256 "cd9a4568dbf9f4d016533dee8d0b6af1ffe5d365e5f38376ce054260a772582a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd6cff53e09a195b69e0aa9e6791e63d8061a8fd5bede2dc1fef7a2efc0a31c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ca2df5264e267256e71030f4ae58c689c92410e83a3c5d207b0477c98eab1d3"
    sha256 cellar: :any_skip_relocation, catalina:      "d77083a0f94473f2884e182a2bcd3773c0829bfa933e9a2a964a91bde1dcb0c9"
    sha256 cellar: :any_skip_relocation, mojave:        "6236e184395b9e307600e41fbfef4dc35f7e9124940545367acb6a5ad5db48ed"
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
