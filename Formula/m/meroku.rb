class Meroku < Formula
  desc "Easy infrastructure management"
  homepage "https://madappgang.com"
  url "https://github.com/MadAppGang/infrastructure/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "c7b2ac49923b36978809f5fbc601764c82b44689bee796f21b6bddd2236cf439"
  license "MIT"

  depends_on "go" => :build

  def install
    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    # meroku requires TTY for AWS profile selection
    # Just verify the binary exists and is executable
    assert_predicate bin/"meroku", :exist?
    assert_predicate bin/"meroku", :executable?
  end
end
