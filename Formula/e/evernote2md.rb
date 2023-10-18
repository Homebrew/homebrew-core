class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.19.0.tar.gz"
  sha256 "ce0946309f6d2f8ce51f2fca38b235e51cdc4b2aa7de2d5fb5c9a987ab9c36b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2777d593637110967665f9957f58d8f3f4ba1e8a371bcbc77f4cbf3146536e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9c586c780a1e76d18a828747655cf89c3ce507ba2ef10fbc0f3827fded89b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9c586c780a1e76d18a828747655cf89c3ce507ba2ef10fbc0f3827fded89b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9c586c780a1e76d18a828747655cf89c3ce507ba2ef10fbc0f3827fded89b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc1f859b40494b26f35d394e8d6d4397e93c991e5c4558881aaaa8dfb0097250"
    sha256 cellar: :any_skip_relocation, ventura:        "2b66a4deab42e9e56ea95130465a53bea3d99555b76e585c6dd82c038fe26ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "2b66a4deab42e9e56ea95130465a53bea3d99555b76e585c6dd82c038fe26ad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b66a4deab42e9e56ea95130465a53bea3d99555b76e585c6dd82c038fe26ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc812906c17500295a697533ceee96ca437331284beac67023ff3b0d1ea0f2e3"
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
