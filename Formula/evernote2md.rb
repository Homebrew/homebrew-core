class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.14.0.tar.gz"
  sha256 "9dcdd838ac6a260c4a96345f6e0927dd0254c01272023976a58ca714d61f49da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1887f7e62decddd7bdb004a9ac813c892a71f9598b4767be67e5a8b53aabf8b0" => :big_sur
    sha256 "da80b7d5d975ff6216e117ffc5d4b2a8240ec0cb276947c2304e588de613558c" => :arm64_big_sur
    sha256 "14fc0cf4058c4e335c562ac627a1e1d764fe6a2f16708fd5a382eedcf568d8e7" => :catalina
    sha256 "aac9b423d5a0b42f06c94c0ecc01354cd4a522d83cacb2454d4bc19d12751d7f" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
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
