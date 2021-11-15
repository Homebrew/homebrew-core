class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.17.1.tar.gz"
  sha256 "7b8c06946087ebb836d35ad7d3b4ddde1b04ad2f4665d650c9a08f7253ddf28c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ce699f257c3e922898dc8e6d33ca5dc4d5ae559b06d81c0c7d6a34d7bdfa6a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33d36b0a5974b354e8a201ee37459d8519a004a8d0509dc3d749ecbb99f50359"
    sha256 cellar: :any_skip_relocation, monterey:       "da8e0bf1585999d61f0e45896f0ca043bec60e7acf446c4832689e5628494508"
    sha256 cellar: :any_skip_relocation, big_sur:        "24feff7c81d04563edf3e64817f8a96ffbdf47b75ef28996f31b983f2e19de6f"
    sha256 cellar: :any_skip_relocation, catalina:       "95aa6c17e693b722784538a4b2444f9cbdae8136d2c3d0d8deb262f40f775f72"
    sha256 cellar: :any_skip_relocation, mojave:         "91e8f33f29c360f232c81a217ca84105af86bb561546afca4ceca65925747810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f8dfa74d4fc4cfa6a3b7688953d011fd5303eecd703f76cc4814f67683abbe"
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
