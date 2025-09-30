class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2025-08-26"
  sha256 "9d3139e90e187f556cbb52db55ffa86041030455ca2941923b78602500216b72"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/objconv\.zip,.*?last\s+modified:\s+(\d{4}-(?:[a-z]+|\d{2})-\d{2})/im)
    strategy :page_match do |page, regex|
      date = page[regex, 1]
      next if date.blank?

      Date.parse(date).strftime("%Y-%m-%d")
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951098c346387a5bf69bad728d32a55e841f1271fe24ed92cb5233be23ba1286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f2031dd481252fccd85513a7ccb457aed4ca0ed6451da911bbe383a80a3ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3dea48ff70c11046b0c6ab661a0efb191261514c486b30ae21bd91908b9c438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f7c973fc476b706d1be47e0e67f9219cf712fbf5cb99c4b4faf7aed158c6b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5cde2fb22722ed1ada6a917bd64201a384c5b27177c1c18e3f0125896d5738"
    sha256 cellar: :any_skip_relocation, ventura:       "3a14af46a9cdaaed26f95746e7b85ec1dd955a2984e4eeee0302385e0023aa86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a32703dbf10ec2be67f3fccc66f57a71bf4cea37f1b63a00a7c9468fad18f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bb71f14f12af7e7381acb20f8ddbb8913bc891015a1366e6fb58c6e9c0dc6a"
  end

  uses_from_macos "unzip" => :build

  def install
    system "unzip", "source"
    system "./build.sh"

    bin.install "objconv"
    doc.install "objconv-instructions.pdf"
  end

  test do
    (testpath/"foo.c").write "int foo() { return 0; }\n"

    system "make", "foo.o"
    assert_match "foo", shell_output("nm foo.o")

    # Rename `foo` to `main`. At least one of `make` or `./bar` will fail if this did not succeed.
    sym_prefix = OS.mac? ? "_" : ""
    system bin/"objconv", "-nr:#{sym_prefix}foo:#{sym_prefix}main", "foo.o", "bar.o"
    system "make", "bar"
    refute_match "foo", shell_output("nm bar")
    system "./bar"
  end
end
