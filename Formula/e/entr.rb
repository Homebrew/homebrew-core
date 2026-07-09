class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.8.tar.gz"
  sha256 "dc9a2bdc556b2be900c1d8cdf432de26492de5af3ffade000d4bfd97f3122bfb"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838218c42fb25f73f78c0a68631333ebc9372cb2b5fc21c4facbee3d94639596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1df251e5b118f90f573327376353af95ffebdd858f411074edc70d57fbe49667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609efce32b36a2faac1a8bf25a003517513ec3cbca5d79cabdefa676f0039b95"
    sha256 cellar: :any_skip_relocation, sonoma:        "310c5ae14c62db4d53d5e1c007e7e02b1c723c4098946bcc88ea6b42ab6523b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2770c4fdd3add4a0c511fa16018883398c60398675f33c0865b886a20ce49ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be565d82b4b77bda77413c369cce336b188cb752a74c21a75ac87a227b8fb60a"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 2
      touch testpath/"test.2"
    end

    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath.to_s).strip
  end
end
