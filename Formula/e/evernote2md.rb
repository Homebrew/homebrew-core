class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "c70750c4bd4663a1b4c65e891d435dfa4d767adc9f1bd3ecd3a058614a36e069"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3869960c1977b11cd0360d58c3db4259314cb18b97601b5fc9fc2dae1760e82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bf9ee9c29c1bab70f6d194e93130473203177676b90b7d63e04332e91267147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68c73cce298d3315e06dbe25a5612850e6386a769e6f6390b18cb8f69e1edd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "72e140709eea3bd9b67b968f74b87f85451880f0c1de7d0965708c43124dca11"
    sha256 cellar: :any_skip_relocation, ventura:        "fd98cef63b3d5b557ea7092f53f3107aa57a26ee04501492dad2588080821aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "3b6eb8c695e2108b3b8229726554faa2422e16bb078576e42d79f513170a8485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8868a8c4f130d7f44768063b569e636468ac23d1a1625c7f115f7eb7414be1f4"
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
