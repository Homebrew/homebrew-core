class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "643b6f12f2a6874293f7ed0c0de69089cd5c7cd8ee30899f1a85f9a63008fd9d"
  license "MIT"
  head "https://github.com/wormi4ok/evernote2md.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc05023d2f533a633f39bdc2b459410d5641f34d25ad36869564cfb1a5588b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc05023d2f533a633f39bdc2b459410d5641f34d25ad36869564cfb1a5588b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc05023d2f533a633f39bdc2b459410d5641f34d25ad36869564cfb1a5588b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7dbea9edb565c916a6421b4ccca7e02bbc3103717363865a48bcca01988c110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "355b84e80e8c95f159d6c1323b5765177b4b285139aede2db278ab44dd89577d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6aabd701ef98384847b5911bc5740aac59ef85bf9792c52145fec41f344449"
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
