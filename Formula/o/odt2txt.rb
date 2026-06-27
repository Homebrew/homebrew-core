class Odt2txt < Formula
  desc "Convert OpenDocument files to plain text"
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/refs/tags/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"
  license "GPL-2.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca8de3bdaff0abb474769434e2e6092d96befa2c79d741d387ea29be3c5c0969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff99e00af2117a1c83d6a07d49286d93270c76e1be4b3fef4b5834daecda6a1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d97dc3cf0b9cc3f503e98ec8bfc5fc175742f580db47d291ed1e325c49c85f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "b554ee321e2dae2d44819148d0d1d6a01f5565df9d899f129a5d975a4454e353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762a04dc77992f1dd8040b8a922808bc103aa52b8a3a83e9a4270474aa778dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742559144816885e1eaaa016a1ab273445fd6d31ebb9e4b636ede27c4963df4d"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    resource "homebrew-sample" do
      url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
      sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
    end

    testpath.install resource("homebrew-sample")
    system bin/"odt2txt", "sample-1.odt"
  end
end
