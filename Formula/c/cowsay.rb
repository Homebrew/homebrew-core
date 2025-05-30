class Cowsay < Formula
  desc "Apjanke's fork of the classic cowsay project"
  homepage "https://cowsay.diamonds"
  url "https://github.com/cowsay-org/cowsay/archive/refs/tags/v3.8.4.tar.gz"
  sha256 "c15bc10712835d3a9bcda780dc9453362567bf48d1185905dc7ef2334d79aadd"
  license "GPL-3.0-only"
  head "https://github.com/cowsay-org/cowsay.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "345e99255a69e9cb188a5a8e6bd8e6f50c334830c8a72877fc6b504c95e5cbd1"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
