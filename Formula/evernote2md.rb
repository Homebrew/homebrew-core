class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.15.0.tar.gz"
  sha256 "f909577900a1a39f0f139669d65e0cc6d0d85509f530f906cd428db457673af0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b94767dc843d2bffb64165848dedcf63b8dad3481fff9521c7b78d7ca72eb33"
    sha256 cellar: :any_skip_relocation, big_sur:       "103b578aa866ced9ae48ee25df6f625494ab59f051eaaf3979ad5b9bd28c0d74"
    sha256 cellar: :any_skip_relocation, catalina:      "5be2a7ca409b059f130ce1e7cdff788544ad93acee33ff9c5c1fa06849e1a468"
    sha256 cellar: :any_skip_relocation, mojave:        "3d3602df533fb9c37f4d491847340b40a9e2efff2419acdb12e1c5dffbfc8643"
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
