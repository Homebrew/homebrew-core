class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.4.tar.gz"
  sha256 "491dded2cc3f1dcd8d26f496a4c7b3a996b91c7ab20883ca375037a398221f9e"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a77db1f5b5246e0ed1df9497b8eb483fa6c59c75850da70689a0d3511148354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec80e77f2f052b7aaae63b79c80497ac5cd3bdcc4de21281abd3cfbb829e45e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc21dd7b56ba1f0a1ffc4bbddb2353c398205d0cfc225a93f7673cd73a439f22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff084ab8ee4c0df0016185292b55736a307a917e087044533e7b242aff939c4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "baa95fc2a0011e16095338d5f7fe8638497b616c3dec0c53b9a2f516a2b2e9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "76cbfd833ca280553b8ed5c078e81f41f3c43e9296f66ce3b8c01870de21c307"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4f2a76e68ad38b7ffa667e21775a4c460fabf930861abb8cd5c463b8575dbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "950ab77d1b5d5bf2b85acae7ed46491e588fe538af0bf1dde369b4f9332739ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e517cacc6f4600412ca201306e6a1240a5261ac159160f0101b3f9b68398722"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end
