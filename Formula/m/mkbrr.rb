class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "8ae71c48e7615b6753f3d10dc255ecc6a41985a000b263f2d69aac467afb4fdc"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bbd8371f8f34981a60227fed3b54ec24225f8a621c2f729ba93a643c1272f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbd8371f8f34981a60227fed3b54ec24225f8a621c2f729ba93a643c1272f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbd8371f8f34981a60227fed3b54ec24225f8a621c2f729ba93a643c1272f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14b5fae3a96620ba0abd81471553d1e130aab84b6858cb850fc9439032030c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aaf4a309c68c3226af1c857b6aaf2c9a32da2bd9e97ac501eebd29203605bc0"
    sha256 cellar: :any,                 x86_64_linux:  "5e2fb50b3c294bca1e67fc59b32275867a09c6b05f51cb50a3195ead2bfc374a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
