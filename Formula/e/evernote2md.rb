class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8de1e94bec536a65f1fa07ef34e0c4f7a0f88e31c87923a4d12558934a69aeab"
  license "MIT"
  head "https://github.com/wormi4ok/evernote2md.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f558642a750e7e44b872d97f8325c99cb3facec262d208202c172de0015fb2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f558642a750e7e44b872d97f8325c99cb3facec262d208202c172de0015fb2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f558642a750e7e44b872d97f8325c99cb3facec262d208202c172de0015fb2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce72d4baa0f3f2418659d1cc14e0113c3199ba5283cf2061792b3495d3e6f4c"
    sha256 cellar: :any_skip_relocation, ventura:       "dce72d4baa0f3f2418659d1cc14e0113c3199ba5283cf2061792b3495d3e6f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45f0edc9169599503c9d069ac2ca5ff41d2e7a358488f7f58aad6f33cdd1f56"
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
