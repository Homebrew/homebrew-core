class BzrXmloutput < Formula
  desc "Bazaar plugin that provides a option to generate XML output"
  homepage "https://launchpad.net/bzr-xmloutput"
  url "https://launchpad.net/bzr-xmloutput/trunk/0.8.8/+download/bzr-xmloutput-0.8.8.tar.gz"
  sha256 "73b9b2f6ce4d9910031df7fd153d56d14f833c20a106f099bee5a33463f73b36"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb0f2bde2a3d23624cf9d0215149d0f72c1c52f9be66fcfea51e833255a42245"
  end

  deprecate! date: "2021-08-19", because: :unsupported

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/xmloutput").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "sample"
    system "bzr", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"

    cd "sample/trunk" do
      msg = "my commit"
      system "bzr", "add", "test.txt"
      system "bzr", "commit", "-m", msg
      assert_match(/<message>.*#{msg}/, shell_output("bzr log --xml"))
    end
  end
end
