class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2025-10-30"
  sha256 "301149c271ffaf7b11a14d7aff637ecd580f8591bb8992b8e399af7ed4779bf9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5273156ed17314c65abfd7ca9a76776fada0abb44c07fc94a6b0702976085600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b630adc4d0dcc0034547ca31047d72a38fb519b9d4e21ac6a54733722280cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "791d4922ed48bd70ecf5b8e15e030f7ee2683d71135dedd1b107eb7319767c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13137ee96946b13e9f5dca16bcf2b6bb51db34970908d6cdca9541cef9f2dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8754722ecaa55b9e9c7361bc7ee2927a11d5c2825a81f75b034201bc7b8fc87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33faeb686f6b82f43adaf81920fac9fbae62239c531a6676c857f64050303046"
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
