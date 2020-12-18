class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/2.1.5.tar.gz"
  sha256 "31182a63f2d2002e5dc99e8f809157c18e660a9964cbbc9faa249e131493c635"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ad50723952f3be57618a6d8abe573a0ee3485bcd132f6ef7f6747a676236c8e" => :big_sur
    sha256 "fe80011577eafc2f17973ea265859b41a13064e039179fa663a7cdbcf9199d45" => :catalina
    sha256 "4f19c79953f6e322684eeeda38a79c3a0bdeb05b6665007aa042d8644e555a8d" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
