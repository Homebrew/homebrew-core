class Ggh < Formula
  desc "Recall your SSH sessions"
  homepage "https://github.com/byawitz/ggh"
  url "https://github.com/byawitz/ggh/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "4692a306792444950f45472a01dcef478a5780203d7aaf1b7b959065a190fe64"
  license "Apache-2.0"
  head "https://github.com/byawitz/ggh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d982cd8c4285912f2e5d720c97e3898b346343ad933d96a2c390521c28c6db"
    sha256 cellar: :any_skip_relocation, ventura:       "38d982cd8c4285912f2e5d720c97e3898b346343ad933d96a2c390521c28c6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3aba2f8d471a9989c8645f21fe758f1d91d8e0486d0e1458005ee2cf038a9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d0469db82a510fca7534c6b614a92d7e0e23dd756a808b8e4fc4c1f0f5a9ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "No history found.", shell_output(bin/"ggh").chomp
    assert_equal "No config found.", shell_output(bin/"ggh -").chomp
  end
end
