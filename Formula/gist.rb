class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.2.tar.gz"
  sha256 "149a57ba7e8a8751d6a55dc652ce3cf0af28580f142f2adb97d1ceeccb8df3ad"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d8c49b8c75cec0f4556c30b98e9af9f6f9a9cde0b208d38f6e410538c0763b7" => :high_sierra
    sha256 "5d8c49b8c75cec0f4556c30b98e9af9f6f9a9cde0b208d38f6e410538c0763b7" => :sierra
    sha256 "5d8c49b8c75cec0f4556c30b98e9af9f6f9a9cde0b208d38f6e410538c0763b7" => :el_capitan
  end

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
