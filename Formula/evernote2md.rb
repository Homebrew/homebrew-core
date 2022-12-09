class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.18.1.tar.gz"
  sha256 "7657a93c069674cdd63b5b10c3746afc27b3f100a99dfdf5c7797d6316ab5c80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02cbb1fa357d681277a0b4f046cb75aa952ede26fcfde8a5d11e7f065dbedc56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d45306252f1dd5bbd7ded3115ccfdba6740cb67fdad70bd5bbcbd83cdceef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1557c34b5e7cca74b6dd60bf27658a93b87b38f4bad245686239fc82eac582bf"
    sha256 cellar: :any_skip_relocation, ventura:        "46f842b5e15f3d07bafe9c00b335a2d0519e1ee1ddf93a5d6a909276f755fdc3"
    sha256 cellar: :any_skip_relocation, monterey:       "a45395b345cc446d72afc9fa47fca285e2807cc8465cf5b85bf5631ed0fc6825"
    sha256 cellar: :any_skip_relocation, big_sur:        "43005070722194a3f73833d5b2e53a371ce58ebcf0b70e5641929604df30e695"
    sha256 cellar: :any_skip_relocation, catalina:       "73976d8face6a9cdebc8796b70370fa79eb464d77bf16dab3c2c03f81e309c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9a0064b54faba9d18b94bdb751e04ddbef1808d0f66e205aa12ae506a288e7"
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
