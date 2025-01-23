class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "1294c3afca183dead839fd283f08068dbbb94170cd8a217400f4bd92dbcfe053"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79548e013256f557c678598fd861e702a43e919c4a0915c2bd7dbdd62b4c43f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79548e013256f557c678598fd861e702a43e919c4a0915c2bd7dbdd62b4c43f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79548e013256f557c678598fd861e702a43e919c4a0915c2bd7dbdd62b4c43f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaafb645a84063e3325ba3db745bed5520b37f37abac7206c2a185fea165a4ea"
    sha256 cellar: :any_skip_relocation, ventura:       "eaafb645a84063e3325ba3db745bed5520b37f37abac7206c2a185fea165a4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b14a4ac7ed27507c31ba72cd6a0cf0fac761f7412f800e38ea71d988b67a2c"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
