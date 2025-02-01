# frozen_string_literal: true

# mkbrr is a fast, single binary tool to create and inspect torrent files
class Mkbrr < Formula
  desc "Fast, single binary tool to create and inspect torrent files"
  homepage "https://github.com/autobrr/mkbrr"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "453bab44ea9f923d2353b11675ed91c297fcbca74be81c905ea819eaded280b9"
  license "GPL-2.0-or-later"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildTime=#{Time.now.utc.iso8601}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")
  end
end
