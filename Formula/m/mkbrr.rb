class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "6a9cadf38b8c5dfed76246eccf44cda1329f39022a720cab44ae5cc4d0c11888"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a16a203bfd66d7372660c91517681544ecf098bf26824bb1bcee4b66a07baadb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16a203bfd66d7372660c91517681544ecf098bf26824bb1bcee4b66a07baadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16a203bfd66d7372660c91517681544ecf098bf26824bb1bcee4b66a07baadb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6884e129bf0b4e50683cf22d4ee942a074652c4fc1d3423757107a688088be4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e47190ec6c29d904b2f243ef360f351b59ea801e63c5a51b6028cda244ab4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d15fb744e91594de2f4c285583130e4965938146877fc492f56cc2afa4048ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version={version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
