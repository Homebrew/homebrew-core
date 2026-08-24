class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "14615324b12362e6ee15bf5354cf2db8ea6ce37016fb409126cf334062ab36ee"
  license "MIT"
  head "https://github.com/wormi4ok/evernote2md.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b6f23858526f56b54c0504266bf3d95b1b428e60a52a3793645136a63fbe86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b6f23858526f56b54c0504266bf3d95b1b428e60a52a3793645136a63fbe86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b6f23858526f56b54c0504266bf3d95b1b428e60a52a3793645136a63fbe86"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25d78dc8786889fd660da270298f18da738c5301d95851e688bd1069a2c9ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc36cd6c05566fab8f84060221cb8b62dea6c94630d25a14c0f57476934c6fc"
    sha256 cellar: :any,                 x86_64_linux:  "d066314c91b289b86e398a10c440779e780139cc07f7f64d12185805a1209c6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    (testpath/"export.enex").write <<~XML
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
    XML
    system bin/"evernote2md", "export.enex"
    assert_path_exists testpath/"notes/Test.md"
  end
end
