class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.18.2.tar.gz"
  sha256 "e8efb9d4e8a8e420afd26a764b3b0b01c2154d5802ad891f366551e404e44e30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbb1507b87408ae78e94266166810e70517aa194884b6b4f82910d19b0bc0c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb1507b87408ae78e94266166810e70517aa194884b6b4f82910d19b0bc0c0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb1507b87408ae78e94266166810e70517aa194884b6b4f82910d19b0bc0c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "0bab4010e74f30701d3ddd09adedddae03f288f7ff6446b64c4ff569330f8abf"
    sha256 cellar: :any_skip_relocation, monterey:       "0bab4010e74f30701d3ddd09adedddae03f288f7ff6446b64c4ff569330f8abf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bab4010e74f30701d3ddd09adedddae03f288f7ff6446b64c4ff569330f8abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b736f3707aafc42111701178ae6c8f1f061a8a3981e98f3fd4c77aa3bd4abf12"
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
