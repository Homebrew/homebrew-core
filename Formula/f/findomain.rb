class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/9.0.2.tar.gz"
  sha256 "1c98f5634ed19ce36a232f8a955098ae84c2d04dfe20bfcc0f10e6e335b8a562"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f45cad3732dfb8f286e9be640a5546ccb5555809a991e9d49969c20d9e089d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e93d310aeab978fcb802f7dd7c42546ff8d17f358b7c21d9fe33a066e8658139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741ccdabe2c7c68e357fcb4e15f69996c880a79ef242f3d1a2457e141fedf5f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "150a3ca1de07e6b74d227e93161958741f9de9801b4305be1349024ec2303bf5"
    sha256 cellar: :any_skip_relocation, ventura:        "0a9152e5041e328aa0ffac534d9669f75bfc5a8f43649d6f097018cbcdb8c0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1486cbba1a7c495af67292ca74760e389e129da7df3cd4de919c863594d9cfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5267e52927c004cfb03e9dc049d3a9319607d8bce688e8871a0abca3436e191"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
