class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "dccc38d29b552db43262b9876c27e27c7ac0b5658fd34b2866205cdb4bb1a534"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b185f46a02eef6c2f8199c2f53c92ca4c6095ef40821380e5b610394586d1c4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b185f46a02eef6c2f8199c2f53c92ca4c6095ef40821380e5b610394586d1c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "6d0dba5bfe43346c5451035c1c6537744bb4379d83f74d538dae0cafb215ab6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d0dba5bfe43346c5451035c1c6537744bb4379d83f74d538dae0cafb215ab6f"
    sha256 cellar: :any_skip_relocation, catalina:       "6d0dba5bfe43346c5451035c1c6537744bb4379d83f74d538dae0cafb215ab6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a302ce19d6712c42c180629333da4452e38d0e9abafc0e86fca969882b409aca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
