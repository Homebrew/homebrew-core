class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "65e3a0b17ed9e636069e00d9a824b4f7325120da6f31d861d5cec993e14994fd" => :catalina
    sha256 "c301f1669b28ecae813f8af356d24756bec61dc2f00a8afcaffea68f82e6c702" => :mojave
    sha256 "ca4befbca1874c7b17d53268ed650db694c4d7ec09497febd46024e3cc4719ad" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system "#{bin}/cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
