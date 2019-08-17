class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.0.0.tar.gz"
  sha256 "f7e77b6eb69cb4bbd06875ee5a5aec737143c0963e0a5faaf0b84368798686a2"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7ea632ef13d4274c6c8b817b1d58cfeef6d73e2f86e2e87a8fee3c24fb68ce4" => :mojave
    sha256 "c7ea632ef13d4274c6c8b817b1d58cfeef6d73e2f86e2e87a8fee3c24fb68ce4" => :high_sierra
    sha256 "0391c6eb2cbee5ba7e66b0e6e18fb4c57f8aecb978ad891a0179823df45e84af" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
