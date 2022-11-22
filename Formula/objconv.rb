class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2022-08-31"
  sha256 "483c27a4f1dcd8dc9cb712913ab8630835ecdfa5868fc8ece5b95a4245226d61"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b88423921e81d1f15c5ccab35ac80028b90f74a09f22385f49210feca3ac46d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ad214921be4f29fce2c10e0338f0a44511ff0ff5d86ca7961bea508330c148f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9724c974ec6bf4019db01e8a59f1614b411a604ae4a65fcba4105bd66324ed13"
    sha256 cellar: :any_skip_relocation, ventura:        "b83c1a66623b8d301d646e9728503678f10ce0b748bcbe99e08872f6a6f6c152"
    sha256 cellar: :any_skip_relocation, monterey:       "83a397727d2eb4081104d4479c3b87c018d737762b6f66d8c99bbe85311cb3ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "56b733562dbe05686a393e31984fae182d7e3e6ed8d237a5a2f7163f56f9ae8f"
    sha256 cellar: :any_skip_relocation, catalina:       "4d6f7dd36d609935e1d216bc449078ad5c204debb3420494a9ff3bbe82f4e00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe852e6c7ac0d913175b6e7cdd7f4389e589708acb3ffd13c2237994f0efe2c"
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
