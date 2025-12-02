class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.30.tar.gz"
  sha256 "ed2fdc973e1b87da2af83050e560e731b0f3bf5f6b4fd9babc9f60bb2b992443"
  license "BSD-2-Clause"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "11cfc4ca9c93744de8e2be5d04df19e4d2210f813580d74da65a819c54600cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e225f8d820c8a2a106ecaa694d127747e33367cf2a3ad817c6b5252f61368e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b09302d5da1fde775d54d424f6c0170f37f1da1b2513d51b1f823735852828b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0139a6c8bb456eae23940a7c52c35b41312de889f6ef3f83629772939a745bca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ba21ef26f596735cd2c3b7de685190497ad837127b3d1fa5807fc59845243c"
    sha256 cellar: :any_skip_relocation, sonoma:         "45a69a2b921833d1baf72f0d09b468ab454288be54e06a98cba131341b7dca9f"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0846635b36a199106674d2afd42d8e7dea53f853787653cd4ecb6db150ac72"
    sha256 cellar: :any_skip_relocation, monterey:       "22f33f9d9ac7142411fb7d9d7108c630c139a171ab68551adb5338c7bbba265b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8c43387bff6017bb5d5f61ef1ed614bbf73172d5c446fba156f7e4b017ffdfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4be383b6e806721fc89c09ab1e971ad2d5be5922952f8d67141fa765a50d8dc"
  end

  head do
    url "https://gitlab.com/esr/ascii.git", branch: "master"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output("#{bin}/ascii 0x0a")
  end
end
