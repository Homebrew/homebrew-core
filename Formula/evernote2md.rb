class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.12.1.tar.gz"
  sha256 "d2b6d8474620afad8a3992d82bdcb826252a97fc9c6ef526ddf18d59e3a96a9a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d71d40d784234eeef883c7b64bfbc3bf3b88ecd2a86c179f76105800d84b794" => :big_sur
    sha256 "312aea2e8be3636053fce7da50c162fa633757a400e774ec6912dd42ec1e9d1f" => :catalina
    sha256 "2e7e7a2109a7b2860539f1e992013ad97d0489e5c37db47377647060a23a3dbc" => :mojave
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
