class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.0.tar.gz"
  sha256 "7a126933258f197edde16adfa2bfb6623021b6007bc9803cd7128830048fff90"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfd2d56cf14d7455d42a2197142f7b97123e7c4b15c4777b2585f8d46ee70eef"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4186aefe3a002a081ba83e1e35a75d41d44682da64e806993ecd8764488becc"
    sha256 cellar: :any_skip_relocation, catalina:      "4125328a50a6e931e4016390180a8bc2a7bff1ed0366440b8dc1d1f682bc65c6"
    sha256 cellar: :any_skip_relocation, mojave:        "1e0a7d7499b90e00e1a0705f1c38a5125f54e97f2d4bd34c3b16b9be219b93f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
