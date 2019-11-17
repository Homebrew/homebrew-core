class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.3.0.tar.gz"
  sha256 "4b42a057cf950e001a995e5b9b9dcec51dbfde652a486e1a6bf75a942507fae8"

  bottle do
    cellar :any_skip_relocation
    sha256 "26c99b55d3c745bb585248077816dc3673113dd80b1f441461a3e67b178318d7" => :catalina
    sha256 "f32a7a8634d9a7a530d9b93b1aab3414ada1f71b2211db37073dc170908964d2" => :mojave
    sha256 "6e716ee0f9c86c302f3c747f842bad61f0310c52bede3107c68eecc31fec4489" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"berglas"
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
