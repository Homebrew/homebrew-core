class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.1.tar.gz"
  sha256 "822cd37f70152e5985433d2c50c8f6b2ec83aaf11aa31be9fe71486a91744f37"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c63635fea193091acb583d8eb73393e41352cc59a5fe11220358d22e0ea06671"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afff1cc7cb378c0adbeba68828d72fe359939a1adfb7a488397e46123746e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f2445c3b66dee86f0580d704b90988f2ad5cb7b159f6a21983c5cb1ea1fac29"
    sha256 cellar: :any_skip_relocation, sonoma:         "50eb43ff897c468cfb26add39d1b1b973ec19da344da8222abdabbec8f265c62"
    sha256 cellar: :any_skip_relocation, ventura:        "91f5b1159ae75b68e1491c9bfdbada3ef21af05bd215fc9af6c9ba092d7905d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d10274b86084cb156093ac97cbb08f9695721aedc80fddffa9c1dc7bede5ede6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2cb1cdcae5ec0b1ab1cb952a5daba840c03e0e69f7e31ed7867bf6fcb17515"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
