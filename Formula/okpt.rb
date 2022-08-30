class Okpt < Formula
  desc "Healthcare ecosystem built for everyone"
  homepage "https://openkoppeltaal.nl"
  url "https://github.com/openkoppeltaal/homebrew-okpt.git"
  version "0.0.1"
  sha256 "761bce8f13727f395aadceefeca36b5cb675855643da1a8c1485ff0682170d9b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "false"
  end
end
