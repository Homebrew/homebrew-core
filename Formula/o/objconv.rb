class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2023-03-29"
  sha256 "0c5ca8fbc7ef1c4afe3cc7cc9018711a5885afacbe8bcebc48028d1ec90ccc7c"
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

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2b4714a356e16792f3980afc77dc4be1dc71f422b1f018581add5627a7029938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e8ce3fb8918b114d7db84a03abb75f67cdc66f19278aad8cde5b22e11db7522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85414b31d4d8ea9a57997b842eb53f709b5c72783c3bd5c7481b4b5004d72d99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203bc4a3d83551c9ad541a48616c8471affbe9560d16b36b302ae94d2b939f78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b8bc140a605c3aba686d7ba7a28a50ca68b7a8b67cd78bda3e2c95f5c227f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a507a2d6fa3e3459f77ca6803b0b126de5e3ab51303dae842925928a3f7dd32d"
    sha256 cellar: :any_skip_relocation, ventura:        "17dd03b46e6b029335e573035c4ab7fb60bb17ce8a64d83109a711df0ed8124d"
    sha256 cellar: :any_skip_relocation, monterey:       "362a2f558092bd6268378d3248d477a10aa8dd771d54d7f1e8f12f2bd91b9952"
    sha256 cellar: :any_skip_relocation, big_sur:        "2853283d56d4f091e9931fa84f10652f0a9e3df302471bfc523a317b7cd3c02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0377932fae0f1e90636136f000858e53e8ca96e2a00c1554a5a217766b9cb7b"
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
