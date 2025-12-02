class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "1c9f8b6efdc6374fe493be39890d75788cd6e341cd1b0e9abec972ac8d9c6cbf"
  license "MIT"
  head "https://github.com/wormi4ok/evernote2md.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94b86dd0f2fc910f5fd28bb8c6fb72aa3a8df7e0fb17e07842caf0c3cb55db78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4695d5deaf82ebc326e8fd8352df78e1bd0c152ee2019a15fc05b222aea70615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4695d5deaf82ebc326e8fd8352df78e1bd0c152ee2019a15fc05b222aea70615"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4695d5deaf82ebc326e8fd8352df78e1bd0c152ee2019a15fc05b222aea70615"
    sha256 cellar: :any_skip_relocation, sonoma:        "478cce9d01b44842dd82b25fd1660e3447f1de3e85d094c2f54012a197b41c0a"
    sha256 cellar: :any_skip_relocation, ventura:       "478cce9d01b44842dd82b25fd1660e3447f1de3e85d094c2f54012a197b41c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61ead54808398828d01a20218b5e1e4822af7c05238aab1aa945ff6507ead10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a94b33b8d7f6b9bd261156e5a3d417d77bbc0dcf53e18f857984f187a610d8f"
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
    assert_path_exists testpath/"notes/Test.md"
  end
end
