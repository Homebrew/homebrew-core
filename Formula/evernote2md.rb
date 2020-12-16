class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.12.1.tar.gz"
  sha256 "d2b6d8474620afad8a3992d82bdcb826252a97fc9c6ef526ddf18d59e3a96a9a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5112286e26f69a639faf094dcf9250f4e43cb7fbd2d31c33231d98ebab18a4f2" => :big_sur
    sha256 "05cf953e556e1728efd22230241b91537e12d639dfa50235a224847bc2bdff4a" => :catalina
    sha256 "a58cd7491d79ea8309773cfa082b638015b384654be17f7fceda8f4580f7eb4d" => :mojave
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
