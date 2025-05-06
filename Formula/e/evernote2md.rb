class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "524669d942ee8600211d3886a5bf18e578b13d8a3a5fb870bbc9f415523246ad"
  license "MIT"
  head "https://github.com/wormi4ok/evernote2md.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20aa5f0579e02309ed70360a6ac0c5c64b23aa3eed44d95701080b617b36755c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20aa5f0579e02309ed70360a6ac0c5c64b23aa3eed44d95701080b617b36755c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20aa5f0579e02309ed70360a6ac0c5c64b23aa3eed44d95701080b617b36755c"
    sha256 cellar: :any_skip_relocation, sonoma:        "51d91c0d9b3c03bbe5fbbd026f95d25711ec32771c15a080c901f5c2e1eebede"
    sha256 cellar: :any_skip_relocation, ventura:       "51d91c0d9b3c03bbe5fbbd026f95d25711ec32771c15a080c901f5c2e1eebede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3710440661c27df4515ebdfe47aa3949bc1a889839306e603607ab33e9c8ef5e"
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
