class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.14.0.tar.gz"
  sha256 "9dcdd838ac6a260c4a96345f6e0927dd0254c01272023976a58ca714d61f49da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b4898185aa1fabed60a737dc2d9e87b516d58e7790fd870dab3bd7fd326dacb" => :big_sur
    sha256 "3f817932a1968881fd29c64da832be7bc04bbe497d8270ca6a357f382b004b85" => :arm64_big_sur
    sha256 "545d63ce9af061e6e54d9eb8ac0cb17fafbd56c499b9360a39ad227c736d792f" => :catalina
    sha256 "8a30f1809b722ebb7b2a923e8b34941a6341e19c0c9adf520335e43ebfc20428" => :mojave
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
