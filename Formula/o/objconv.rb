class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2026-05-14"
  sha256 "0f604f93f97f689afd7615c86176eb15bc95001eadf8317f17ebd099c50c59e1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f06a2e64300c2685c083fd95df7bef59538666948122ddc86ec034da588d0f08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9c93c8dc00a939a982e3f91ead2bb123398c2d51b16012e884e68940f64279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d273ae1e33ceead2ffd568a7fad04359b97b55c01961d537f58888b594b0a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "62afeccb878f94d41864cc49e74823fc1c9be2d95cdc04547f921cc0c1d41ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0575326904e82bba08aef0be413897313d89fb7046d0dddb3a89b6a56d9fab2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54a33822922a82171119df29ba1f0a86ffb40e5be12ed88863482008a6f57eec"
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
