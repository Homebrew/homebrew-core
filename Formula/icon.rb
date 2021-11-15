class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.21b.tar.gz"
  version "9.5.21b"
  sha256 "5dd46cd4e868c75ff1b50de275f1ec06a09641afcb8c18b072333f97f86d3bcc"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ccc00b4af7b3a086b6b72a1eb42dee8c1ac01862163090d13da1d718b4a5f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f125fa0da1cf68ea312bf3f4b17c2b49491effc3ec55918f5578b7e819b87ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "5b169e29f1af9e4c21f38eb6bae5da048c568fb11e6840de26b14ee89a590141"
    sha256 cellar: :any_skip_relocation, big_sur:        "26221c72cd120274c75db2dca9926ff6d651f380814946005f1bb20fa8a12be9"
    sha256 cellar: :any_skip_relocation, catalina:       "c59f68713faf7424ff485f8e5b3407367d29cd1412af432355c0f6d525d78f71"
    sha256 cellar: :any_skip_relocation, mojave:         "7882a95b7c29003762ee254bc6fb4e2f1ca857edadc679d0802328dfcd0ab7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f219d790f552dba33c724f3bb60bb91392f81ac62df185bebb137d4c8efdfb6e"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "posix"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
